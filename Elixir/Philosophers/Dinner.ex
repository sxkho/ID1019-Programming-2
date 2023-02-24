defmodule Dinner do

	def start(n) do
		spawn(fn -> init(n) end)
	end

	def init(n) do
		c1 = Chopstick.start()
		c2 = Chopstick.start()
		c3 = Chopstick.start()
		c4 = Chopstick.start()
		c5 = Chopstick.start()
		ctrl = self()
		Philosopher.start(n, 2, c1, c2, "Arendt", ctrl)
		Philosopher.start(n, 2, c2, c3, "Hypatia", ctrl)
		Philosopher.start(n, 2, c3, c4, "Simone", ctrl)
		Philosopher.start(n, 2, c4, c5, "Elisabeth", ctrl)
		Philosopher.start(n, 2, c5, c1, "Ayn", ctrl)

		t0 = System.monotonic_time(:second)
		wait(5, [c1, c2, c3, c4, c5], t0)
	end

	def wait(0, chopsticks, t0) do
		t1 = System.monotonic_time(:second)
		Enum.each(chopsticks, fn(c) -> Chopstick.quit(c) end)
		IO.puts(t1 - t0)
	end

	def wait(n, chopsticks, t0) do
		receive do
			:done -> 
				wait(n-1, chopsticks, t0)
			:abort -> 
				Process.exit(self(), :kill)
		end
	end

end