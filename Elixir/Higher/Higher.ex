defmodule Higher do

	# RECURSIVELY TRANSFORMING A LIST # 

	# def double([]) do [] end
	# def double([head | tail]) do [2*head | double(tail)] end

	# def addFive([]) do [] end
	# def addFive([head | tail]) do [5 + head | addFive(tail)] end

	# def animal([]) do [] end
	# def animal([head | tail]) do
		#if (head === :dog) do [:fido | animal(tail)]

	# else [head | animal(tail)] end
	# end 

	def double_five_animal([], _) do [] end
	def double_five_animal([head | tail], tr) do
		case tr do
			:double -> [2 * head | double_five_animal(tail, tr)]
			:five -> [5 + head | double_five_animal(tail, tr)]
			:animal -> 
				if (head === :dog) do [:fido | double_five_animal(tail, tr)]
			else [head | double_five_animal(tail, tr)] end 
		end
	end

	def apply_to_all([], _) do [] end
	def apply_to_all([head | tail], func) do
		[func.(head) | apply_to_all(tail, func)]
	end

	# REDUCING A LIST # 

	# def sum([]) do 0 end
	# def sum([head | tail]) do head + sum(tail) end

	def fold_right([], baseVal, _) do baseVal end
	def fold_right([head | tail], baseVal, func) do
		func.(head, fold_right(tail, baseVal, func))
	end 

	def fold_left([], baseVal, _) do baseVal end
	def fold_left([head | tail], baseVal, func) do
		fold_left(tail, func.(head, baseVal), func)
	end

	# Filter out the good ones # 

	def odd([]) do [] end
	def odd([head | tail]) do
		if (rem(head, 2) == 1) do
			[head | odd(tail)]

		else odd(tail)
		end
	end

	def filter([], _) do [] end
	def filter([head | tail], func) do
		case func.(head) do
			true -> [head | filter(tail, func)]
			false -> filter(tail, func)
		end
	end 

end