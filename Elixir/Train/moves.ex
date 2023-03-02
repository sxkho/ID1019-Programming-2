defmodule Moves do

	# Sequence - Will probably call single

	def sequence([], state) do
		[state]
	end

	def sequence([h | t], state) do
		[state | sequence(t, single(h, state))]
	end


	def single({_, 0}, state) do state end

	def single({:one, n}, {main, one, two}) when n > 0 do
		{0, remaining, take} = Train.main(main, n)
		{remaining, Train.append(take, one), two}
	end

	def single({:one, n}, {main, one, two}) when n < 0 do
		take = Train.take(one, -n)
		{Train.append(main, take), Train.drop(one, -n), two}
	end

	def single({:two, n}, {main, one, two}) when n > 0 do
		{0, remaining, take} = Train.main(main, n)
		{remaining, one, Train.append(take, two)}
	end

	def single({:two, n}, {main, one, two}) when n < 0 do
		take = Train.take(two, -n)
		{Train.append(main, take), one, Train.drop(two, -n)}
	end

	
end