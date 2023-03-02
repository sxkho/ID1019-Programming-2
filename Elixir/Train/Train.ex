defmodule Train do
	
	def take(_, 0) do [] end
	def take([h | t], n) when n > 0 do
		[h | take(t, n - 1)]
	end

	def drop(t, 0) do t end
	def drop([_ | t], n) when n > 0 do drop(t, n - 1) end

	def append([], t2) do t2 end 
	def append([h | t], t2) do
		[h | append(t, t2)]
	end

	def member([], _) do false end
	def member([y | _], y) do true end
	def member([_ | t], y) do member(t, y) end

	def position([y | _], y) do 1 end
	def position([_ | t], y) do 1 + position(t, y) end

	def split([y | t], y) do {[], t} end
	def split([h | t], y) do
		{h2, t2} = split(t, y)
		{[h | h2], t2}
	end 

	def main([], n) do {n, [], []} end
	def main([h | t], n) do
		case main(t, n) do
			{0, remain, take} ->
				{0, [h | remain], take}
			{n, remain, take} ->
				{n-1, remain, [h | take]}
		end
	end

end