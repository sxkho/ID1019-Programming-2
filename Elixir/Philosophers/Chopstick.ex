defmodule Chopstick do
	
	def start do
		stick = spawn_link(fn -> available() end)
		{:stick, stick}
	end

	def available() do
		receive do
			{:request, from} -> 
				send(from, :granted)
				gone()

			{:request, ref, from} ->
        	send(from, {:granted, ref})
            gone(ref)

			:quit -> :ok
		end
	end

	def gone() do
		receive do
			:return -> available()
			:quit -> :ok
		end
	end

	def gone(ref) do
    	receive do
      	{:return, ^ref}->
		available()

      :quit ->
        :ok
    end
  end

	def request({:stick, pid}) do
		send(pid, {:request, self()})
		receive do
			:granted -> :ok
		end
	end

	def request({:stick, pid}, timeout) when is_number(timeout) do
		send(pid, {:request, self()})
		receive do
			:granted -> 
				:ok
			after
				timeout ->
					# IO.puts("DEADLOCK DEADLOCK DEADLOCK RAAAAHHHHHHHHHH")
					:no
		end
	end

	def return({:stick, pid}) do
		send(pid, :return)
	end

	def return({:stick, pid}, ref) do
		send(pid, {:return, ref})
	end

	def asynch({:stick, pid}, ref) do
		send(pid, {:request, ref, self()})
	end

	def synch(ref, timeout) do
		receive do
			{:granted, ^ref} -> 
				:ok
			{:granted, _} -> 
				synch(ref, timeout)
		after timeout -> 
			:no
		end
	end

	def quit({:stick, pid}) do
		send(pid, :quit)
	end

	# Testa med timeout, lägg till timeout för filosoferna när de requestar chopstick, lägg tillbaka left
	# nr 2: Behöver bättre sätt att lämna tillbaks chopsticks -> "keep track of requests", returnera tagged stick
	# Gör båda samtidigt - timeout och keep track of requests
	# Asynch requests?


end