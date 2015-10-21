package eu.crembo;

/**
 * Created by Crembo on 2014-05-13.
 */
public class Task3 {

	// nmber of iterations
	public static final int LIMIT = 100;

	// number of producers and consumers
	public static final int NUM = 2;

	// buffer size
	public static final int BUFFER_SIZE = 2;

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

		System.out.println("Done; Monitors with Semaphores");
	}

	/**
	 * Binary Semaphore implementation using Java monitors
	 */
	public static class Semaphore {
		private int s = 0;

		/**
		 * Default constructor for binary semaphore
		 */
		public Semaphore() {
			this.s = 1;
		}

		/**
		 * Construct with ability to set initial value of the semaphore
		 * @param s
		 */
		public Semaphore(int s) {
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
			s++;
			notifyAll();
		}
	}

	/**
	 * Implementation of monitors using the semaphore implementation created in Task 2.
	 * Detail explanation of this class in attached pdf
	 */
	public static class Monitor {

		// makes sure mutex is acquired for critical sections
		private Semaphore mutex = new Semaphore();
		private Semaphore notifyCalled = new Semaphore(0);

		// count of threads waiting
		private int threadsWaiting = 0;

		/**
		 * What the compilers insert at the beginning of every synchronized method
		 * Detail explanation in attached pdf
		 *
		 * @throws InterruptedException
		 */
		protected void enter() throws InterruptedException {
			mutex.down();
		}

		/**
		 * Equivalent of Object.wait();
		 * Detail explanation in attached pdf
		 *
		 * @param acquired the lock
		 * @return the changed lock, if it was acquired
		 * @throws InterruptedException
		 */
		protected boolean doWait(boolean acquired) throws InterruptedException {
			if (acquired) {
				threadsWaiting--;
				notifyCalled.up();
			}
			threadsWaiting++;
			mutex.up();
			notifyCalled.down();
			mutex.down();
			acquired = true;

			return acquired;
		}

		/**
		 * Equivalent to Object.notifyAll()
		 * Detail explanation in attached pdf
		 *
		 * @throws InterruptedException
		 */
		protected void doNotifyAll() throws InterruptedException{
			while (threadsWaiting > 0) {
				threadsWaiting--;
				notifyCalled.up();
			}
		}

		/**
		 * Equivalent to Object.notify()
		 * Detail explanation in attached pdf
		 *
		 * @throws InterruptedException
		 */
		protected void doNotify() throws InterruptedException {
			if (threadsWaiting > 0) {
				threadsWaiting--;
				notifyCalled.up();
			}
		}

		/**
		 * What the compiler inserts at the end of every synchronized method;
		 * Detail explanation in attached pdf
		 *
		 * @throws InterruptedException
		 */
		protected void exit() throws InterruptedException {
			mutex.up();
		}
	}

	/**
	 * Bounded Buffer class, has the put and get methods.
	 * Extends the Monitor in order to use its custom wait and notify methods.
	 * Modifications when compared to Task 2 code are explained in the pdf.
	 */
	public static class BoundedBuffer extends Monitor {

		public static int first = 0, last = 0, size = BUFFER_SIZE;
		public static int[] items = new int[size];

		// number of items in the buffer
		private int numberInBuffer = 0;

		/**
		 * Put an item into the bounded buffer
		 *
		 * @param itm
		 * @throws InterruptedException
		 */
		public void put(int itm) throws InterruptedException {
			enter();

			boolean acquired = false;
			while (numberInBuffer == size) {
				acquired = doWait(acquired);
			}

			// Critical section
			last = (last + 1) % size;
			items[last] = itm;
			numberInBuffer++;
			System.out.println("Produced. Slot: " + last);

			doNotifyAll();
			exit();
		}

		/**
		 * Take items out of the bounded buffer
		 *
		 * @return the taken item
		 * @throws InterruptedException
		 */
		public int get() throws InterruptedException {
			enter();

			boolean acquired = false;
			while (numberInBuffer == 0) {
				acquired = doWait(acquired);
			}

			// Critical section
			first = (first + 1) % size;
			int item = items[first];
			numberInBuffer--;
			System.out.println("Consumed. Number: " + items[first] + " Slot: " + first);

			doNotifyAll();
			exit();
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