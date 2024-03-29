
public class Formative {

	private static class Writer extends Thread {

		private int[] integers;
		private int write;

		public Writer(int[] integers, int write) {
			this.integers = integers;
			this.write = write;
		}

		public synchronized void run() {
			for (int i = 0; i < integers.length; i++) {

				if ((i + 1) % 2 == 0 && write == 1) {
					try {
						System.out.println("Writer " + write + " is waiting.");
						wait();
					} catch (InterruptedException e) {
						e.printStackTrace();
					}
				} else if ((i + 1) % 2 != 0 && write == 1) {
					System.out.println("Writer " + write + " has notified.");
					notify();
				}

				integers[i] = write;

				if ((i + 1) % 2 == 0 && write == 7) {
					System.out.println("Writer " + write + " has notified.");
					notify();
				} else if ((i + 1) % 2 != 0 && write == 7) {
					try {
						System.out.println("Writer " + write + " is waiting.");
						wait();
					} catch (InterruptedException e) {
						e.printStackTrace();
					}
				}

			}
		}

	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		int[] integers = new int[10];

		Writer w1 = new Writer(integers, 1);
		Writer w2 = new Writer(integers, 7);

		w1.start();
		w2.start();

		try {
			w1.join();
			w2.join();
		} catch (InterruptedException ie) {

		}

		for (int i = 0; i < integers.length; i++) {
			System.out.println(integers[i]);
		}
		System.out.println("");
	}

}
