
public class ExerciseTwo {
	
	private static class Writer extends Thread {
		
		private int[] integers;
		private int write;

		public Writer(int[] integers, int write) {
			this.integers = integers;
			this.write = write;
		}

		public void run() {
			for (int i = 0; i < integers.length; i++) {
				integers[i] = write;
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
