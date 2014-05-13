package eu.crembo;

/**
 * Bounded buffer problem.
 * <p/>
 * 2 Consumers and 2 Producers.
 * Producers puts items into buffer - make sure it doesn't put into full buffer.
 * Consumer uses items from buffer - make sure it doesn't take from empty buffer.
 */
public class Task2 {

	// limits the number	of loops for every consumer and producer
	public static final int LIMIT = 50000;

	// number of producers and consumers
	public static final int NUM = 2;

	// buffer size
	public static final int BUFFER_SIZE = 2;

	// the bounded buffer
	public static BoundedBuffer b;

	public static void main(String[] args) {
		b = new BoundedBuffer();

		Producer[] ps = new Producer[NUM];
		Consumer[] cs = new Consumer[NUM];

		for (int i = 0; i < NUM; i++) {
			cs[i] = new Consumer();
			cs[i].start();
			ps[i] = new Producer();
			ps[i].start();
		}

		try {
			for (int i = 0; i < NUM; i++) {
				ps[i].join();
				cs[i].join();
			}
		} catch (InterruptedException e) {
			e.printStackTrace();
		}

		System.out.println("Done");
	}

	/**
	 * Semaphore implementation using Java monitors
	 *
	 */
	public static class Semaphore {
		private int s = 0, max;

		/**
		 * Default constructor for binary semaphore
		 */
		public Semaphore() {
			this.max = 1;
			this.s = 1;
		}

		/**
		 * Constructor to make counting semaphore
		 *
		 * @param max maximum value of the semaphore
		 * @param s initial value of the semaphore
		 */
		public Semaphore(int max, int s) {
			this.max = max;
			this.s = s;
		}

		/**
		 * Decrease semaphore to get the lock
		 *
		 * @throws InterruptedException
		 */
		public synchronized void down() throws InterruptedException {
			while (s == 0)
				wait();
			s--;
		}

		/**
		 * Increase semaphore
		 *
		 * @throws InterruptedException
		 */
		public synchronized void up() throws InterruptedException {
			while (s == max)
				wait();

			s++;
			notifyAll();
		}
	}

	/**
	 * Bounded Buffer class, has the put and get methods
	 */
	public static class BoundedBuffer {

		private static int first = 0, last = 0, size = BUFFER_SIZE;
		private static int[] items = new int[size];

		// mutex for critical sections
		private static Semaphore mutex = new Semaphore();

		// counting semaphore to know how many empty positions we have; initialise to buffer size
		private static Semaphore emptyCount = new Semaphore(size, size);

		// counting semaphore to know how many full positions we have; initialise to 0
		private static Semaphore fillCount = new Semaphore(size, 0);

		/**
		 * Put an item into the buffer
		 *
		 * @param i item to put
		 * @throws InterruptedException
		 */
		public void put(int i) throws InterruptedException {

			// preparing to put item
			// decrease empty count, if empty is 0 -> wait
			emptyCount.down();
			{
				// critical section start, get mutex
				mutex.down();

				// put item into buffer
				last = (last + 1) % size;
				items[last] = i;
				System.out.println("Produced. Slot: " + last);

				// critical section end, return mutex
				mutex.up();
			}
			fillCount.up();
			// item put into buffer, increase fill count
		}

		/**
		 * Get an item from the buffer
		 *
		 * @throws InterruptedException
		 */
		public int get() throws InterruptedException {
			int item;

			// preparing to get item
			// decrease fill count, if fill is 0 -> wait
			fillCount.down();
			{
				// start of critical section, get mutex
				mutex.down();

				// get item
				first = (first + 1) % size;
				item = items[first];
				System.out.println("Consumed. Number: " + items[first] + " Slot: " + first);

				// end of critical section, return mutex
				mutex.up();
			}
			emptyCount.up();
			// item removed from buffer, increase empty count

			return item;
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
