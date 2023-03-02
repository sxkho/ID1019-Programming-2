defmodule Shunt do
	
	def find([], []) do [] end
	def find(xs , [y | ys]) do
		{hs, ts} = Train.split(xs, y)
	    tn = length(ts)
    	hn = length(hs)    
    	[{:one, tn+1}, {:two, hn}, {:one, -(tn+1)}, {:two, -hn} | find(Train.append(hs, ts), ys)]
	end

	def few([], []) do [] end
	def few(xs, [y | ys]) do
		[h | t] = xs
		if (h == y) do
			few(t, ys)
		else
			{hs, ts} = Train.split(xs, y)
			tn = length(ts)
			hn = length(hs)
			[{:one, tn+1}, {:two, hn}, {:one, -(tn+1)}, {:two, -hn} | few(Train.append(hs, ts), ys)]
		end
	end

	# def fewer([], _, _, []) do [] end
	# def fewer(ms, os, ts, [y | ys]) do
		# if (Train.member(ms, y)) do
			# {hs, ts2} = Train.split(ms, y)
			# tn = length(ts2)
			# hn = length(hs)
			# [{:one, tn+1}, {:two, hn} | fewer(Train.append(hs, ts2), [], [], ys)]
		# end

	# end

	def compress(ms) do
		ns = rules(ms)
		if (ns == ms) do
			ms
		else
			compress(ns)
		end
	end

	def rules([]) do [] end
	def rules([{_, 0} | t]) do
		rules(t)
	end
	def rules([{:one, n}, {:one, m} | t]) do
		rules([{:one, n+m} | t])
	end
	def rules([{:two, n}, {:two, m} | t]) do
		rules([{:two, n+m} | t])
	end
	def rules([h | t]) do
		[h | rules(t)]
	end 

end