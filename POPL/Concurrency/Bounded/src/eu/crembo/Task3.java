package eu.crembo;

/**
 * Created by Crembo on 2014-05-13.
 */
public class Task3 {
	public static final int LIMIT = 50000;
	public static final int CONSUMER_NUM = 2;
	public static final int PRODUCER_NUM = 2;

	public static BoundedBuffer b;

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

		System.out.println("Done; Monitors with Semaphores");
	}

	public static class Semaphore {
		private int s = 0;

		public Semaphore() {
			this.s = 1;
		}

		public Semaphore(int s) {
			this.s = s;
		}

		public synchronized void down() throws InterruptedException {
			while (s == 0)
				wait();
			s--;
		}

		public synchronized void up() throws InterruptedException {
			s++;
			notifyAll();
		}
	}

	public static class BoundedBuffer {

		public static int first = 0, last = 0, size = 2;
		public static int[] items = new int[size];

		// Monitor variables
		private Semaphore monitorSemaphore = new Semaphore();
		private Semaphore notifyCalled = new Semaphore(0);

		private int blocksWaitingCount = 0;
		private int numberInBuffer = 0;

		public void put(int itm) throws InterruptedException {

			monitorSemaphore.down();

			boolean acquired = false;
			while (numberInBuffer == size) {
				// Equivalent of wait()
				if (acquired) {
					decThreads();
					notifyCalled.up();
				}
				incThreads();
				monitorSemaphore.up();
				notifyCalled.down();
				monitorSemaphore.down();
				acquired = true;
			}

			// Critical section
			last = (last + 1) % size;
			items[last] = itm;
			numberInBuffer++;
			System.out.println("Produced. Slot: " + last);

			// Equivalent of notifyAll()
			for (int i = getThreadsWaiting(); i > 0; i--) {
				decThreads();
				notifyCalled.up();
			}

			monitorSemaphore.up();
		}

		public void get() throws InterruptedException {
			monitorSemaphore.down();

			boolean acquired = false;
			while (numberInBuffer == 0) {
				// Equivalent of wait()
				if (acquired) {
					decThreads();
					notifyCalled.up();
				}
				incThreads();
				monitorSemaphore.up();
				notifyCalled.down();
				monitorSemaphore.down();
				acquired = true;
			}

			// Critical section
			first = (first + 1) % size;
			numberInBuffer--;
			System.out.println("Consumed. Number: " + items[first] + " Slot: " + first);

			// Equivalent of notifyAll()
			for (int i = getThreadsWaiting(); i > 0; i--) {
				decThreads();
				notifyCalled.up();
			}

			monitorSemaphore.up();
		}

		private void incThreads() {
			blocksWaitingCount++;
		}

		private void decThreads() {
			blocksWaitingCount--;
		}

		private int getThreadsWaiting() {
			return blocksWaitingCount;
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
}
