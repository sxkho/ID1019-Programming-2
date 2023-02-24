defmodule Philosopher do

	@dream 800
    @eat 100
    @delay 200

    @timeout 1000
	
	defp delay(t), do: sleep(t)

    defp sleep(0), do: :ok
    defp sleep(t), do: :timer.sleep(:rand.uniform(t))

	def start(hunger, strength, left, right, name, ctrl) do
		spawn_link(fn -> init(hunger, strength, left, right, name, ctrl) end)
	end

	def init(hunger, strength, left, right, name, ctrl) do
		dreaming(hunger, strength, left, right, name, ctrl)
	end

	# Philosopher is dreaming
	def dreaming(0, strength, _, _, name, ctrl) do
		IO.puts("#{name} is happy! Strength is #{strength}")
		send(ctrl, :done)
	end

	def dreaming(_hunger, 0, _left, _right, name, ctrl) do
		IO.puts("#{name} has starved")
		send(ctrl, :done)

	end

	def dreaming(hunger, strength, left, right, name, ctrl) do
		IO.puts("#{name} is dreaming")

		delay(@dream)

		IO.puts("#{name} woke up!")
		waiting(hunger, strength, left, right, name, ctrl)
	end

	# Waiting for chopsticks
	def waiting(hunger, strength, left, right, name, ctrl) do
		IO.puts("#{name} is waiting for chopsticks, #{hunger} to go!")

		#ref = make_ref()
		#Chopstick.asynch(left, ref)
		#Chopstick.asynch(right, ref)

		#case Chopstick.synch(ref, @timeout) do
		case Chopstick.request(left, @timeout) do
			:ok -> 
				IO.puts("#{name} received left chopstick!")
				delay(@delay)
				IO.puts("After delay")

				#case Chopstick.synch(ref, @timeout) do
				case Chopstick.request(right, @timeout) do
					:ok -> 
						IO.puts("#{name} received both sticks!")
						eating(hunger, strength, left, right, name, ctrl)
					:no -> 
						Chopstick.return(left)
						dreaming(hunger, strength, left, right, name, ctrl)
				end

			:no -> 
				dreaming(hunger, strength, left, right, name, ctrl)

		end
	end

	def eating(hunger, strength, left, right, name, ctrl) do
		IO.puts("#{name} is eating! Strength is #{strength}")
		delay(@eat)

		Chopstick.return(left)
		Chopstick.return(right)

		dreaming(hunger - 1, strength, left, right, name, ctrl)
	end
	
end