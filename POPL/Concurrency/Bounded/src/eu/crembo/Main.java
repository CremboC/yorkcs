package eu.crembo;

/**
 * Bounded buffer problem.
 *
 * 2 Consumers and 2 Producers.
 * Producers puts items into buffer - make sure it doesn't put into full buffer.
 * Consumer uses items from buffer - make sure it doesn't take from empty buffer.
 */
public class Main {

	public static final int LIMIT = 50000;

	public static BoundedBuffer b;

	public static class Semaphore {
		private int s = 0, max;

		public Semaphore() {
			this.max = 1;
			this.s = 1;
		}

		public Semaphore(int max, int s) {
			this.max = max;
			this.s = s;
		}

		public synchronized void down() throws InterruptedException {
			while (s == 0)
				wait();
			s--;
		}

		public synchronized void up() throws InterruptedException {
			while (s == max)
				wait();

			s++;
			notifyAll();
		}
	}

	public static int first = 0, last = 0, size = 2;

	static Semaphore mutex = new Semaphore();
	static Semaphore emptyCount = new Semaphore(size, size);
	static Semaphore fillCount = new Semaphore(size, 0);

	public static int[] items = new int[size];

	public static class BoundedBuffer {

		public void put(int i) throws InterruptedException {
			emptyCount.down();
			{
				mutex.down();

				last = (last + 1) % size ; // % is modulus
				items[last] = i;
				System.out.println("Produced. Slot: " + last);

				mutex.up();
			}
			fillCount.up();
		}

		public void get() throws InterruptedException {

			fillCount.down();
			{
				mutex.down();

				first = (first + 1) % size ; // % is modulus
				System.out.println("Consumed. Number: " + items[first] + " Slot: " + first);

				mutex.up();
			}
			emptyCount.up();
		}

	}

	public static class Producer extends Thread {
		public void run() {
			int i = 0;

			while (i < LIMIT) {
				try {
					b.put(i);
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
				i++;
			}
		}
	}

	public static class Consumer extends Thread {
		public void run() {
			int i = 0;

			while (i < LIMIT) {
				try {
					b.get();
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
				i++;
			}

		}
	}

	public static final int CONSUMER_NUM = 2;
	public static final int PRODUCER_NUM = 2;

    public static void main(String[] args) {
	    b = new BoundedBuffer();

		Producer[] ps = new Producer[PRODUCER_NUM];
	    Consumer[] cs = new Consumer[CONSUMER_NUM];

	    for (int i = 0; i < CONSUMER_NUM; i++) {
		    cs[i] = new Consumer();
		    cs[i].start();
	    }

	    for (int i = 0; i < PRODUCER_NUM; i++) {
		    ps[i] = new Producer();
		    ps[i].start();
	    }

	    try {
		    for (int i = 0; i < PRODUCER_NUM; i++) {
			    ps[i].join();
		    }

		    for (int i = 0; i < CONSUMER_NUM; i++) {
			    cs[i].join();
		    }
	    } catch (InterruptedException e) {
			e.printStackTrace();
	    }

	    System.out.println("Done");
    }
}
