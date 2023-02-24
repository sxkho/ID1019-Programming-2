defmodule M do
	@type literal() :: {:num, number()} | {:var, atom()}

	@type expr() :: {:add, expr(), expr()}
	            | {:mul, expr(), expr()}
	            | {:exp, expr(), literal()}
	            | {:ln, expr()}
	            | {:frac, expr(), expr()}
	            | {:sub, expr(), expr()}
	            | {:sqr, expr()}
	            | {:sin, expr()}
	            | {:cos, expr()}
	            | literal()

    def test() do
    	e = {:var, :x}

    d = deriv(e, :x)
    IO.write("Expression: #{pprint(e)}\n")
    IO.write("Derivative: #{pprint(d)}\n")
    IO.write("Simplified: #{pprint(simplify(d))}\n")
    end

    def test2() do
    	e = {:add, 
    		{:exp, {:var, :x}, {:num, 3}},
    		{:num, 4}
    	}

    d = deriv(e, :x)
    IO.write("Expression: #{pprint(e)}\n")
    IO.write("Derivative: #{pprint(d)}\n")
    IO.write("Simplified: #{pprint(simplify(d))}\n")
    end

    def test3() do
    	e = {:add, {:ln, {:exp, {:var, :x}, {:num, 2}}}, {:num, 3}}

    d = deriv(e, :x)
    IO.write("Expression: #{pprint(e)}\n")
    IO.write("Derivative: #{pprint(d)}\n")
    IO.write("Simplified: #{pprint(simplify(d))}\n")
    end

    def test4() do
    	e = {:frac, {:num, 1}, {:var, :x}
    	}

    d = deriv(e, :x)
    IO.write("Expression: #{pprint(e)}\n")
    IO.write("Derivative: #{pprint(d)}\n")
    IO.write("Simplified: #{pprint(simplify(d))}\n")
    end

    def testfrac() do
    	e = {:mul, {:num, -1}, {:frac, {:num, 1}, {:exp, {:var, :x}, {:num, 2}}}
    	}

    d = deriv(e, :x)
    IO.write("Expression: #{pprint(e)}\n")
    IO.write("Derivative: #{pprint(d)}\n")
    IO.write("Simplified: #{pprint(simplify(d))}\n")
    end

    def test5() do
    	e = {:frac, {:num, 2}, {:exp, {:var, :x}, {:num, 3}}
    	}

    d = deriv(e, :x)
    IO.write("Expression: #{pprint(e)}\n")
    IO.write("Derivative: #{pprint(d)}\n")
    IO.write("Simplified: #{pprint(simplify(d))}\n")
    end

    def test6() do
    	e = {:sqr, {:var, :x}}

    d = deriv(e, :x)
    IO.write("Expression: #{pprint(e)}\n")
    IO.write("Derivative: #{pprint(d)}\n")
    IO.write("Simplified: #{pprint(simplify(d))}\n")
    end

    def test7() do
    	e = {:sin, {:mul, {:num, 2}, {:var, :x}}}

    d = deriv(e, :x)
    IO.write("Expression: #{pprint(e)}\n")
    IO.write("Derivative: #{pprint(d)}\n")
    IO.write("Simplified: #{pprint(simplify(d))}\n")
    end

	def deriv({:num, _}, _) do {:num, 0} end
	def deriv({:var, v}, v) do {:num, 1} end
	def deriv({:var, _}, _) do {:num, 0} end

	def deriv({:add, e1, e2}, v) do 
		{:add, deriv(e1, v), deriv(e2, v)}
	end

	def deriv({:mul, e1, e2}, v) do
		{:add, 
		{:mul, deriv(e1, v), e2}, 
		{:mul, e1, deriv(e2, v)}}
	end

	def deriv({:exp, e, {:num, n}}, v) do
		{:mul, {:mul, 
		{:num, n}, {:exp, e, {:num, n-1}}}, deriv(e, v)}
	end

	def deriv({:ln, e}, v) do
		{:mul, {:frac, {:num, 1}, e}, deriv(e, v)}
	end

	def deriv({:frac, e1, e2}, v) do
		{:frac, {:sub, {:mul, deriv(e1, v), e2}, {:mul, e1, deriv(e2, v)}}, {:exp, e2, {:num, 2}}}
	end

	def deriv({:sqr, e1}, v) do
		{:mul, {:frac, {:num, 1}, {:mul, {:num, 2}, {:sqr, e1}}}, deriv(e1, v)}
	end

	def deriv({:sin, e}, v) do
		{:mul, deriv(e, v), {:cos, e}}
	end

	def deriv({:cos, e}, v) do
		{:mul, {:num, -1}, {:mul, deriv(e, v), {:sin, e}}}
	end

	

	def simplify({:add, e1, e2}) do 
		simplify_add(simplify(e1), simplify(e2))
	end
	def simplify({:mul, e1, e2}) do 
		simplify_mul(simplify(e1), simplify(e2))
	end
	def simplify({:exp, e1, e2}) do
		simplify_exp(simplify(e1), simplify(e2))
	end
	def simplify({:sub, e1, e2}) do
		simplify_sub(simplify(e1), simplify(e2))
	end
	def simplify({:frac, e1, e2}) do
		simplify_frac(simplify(e1), simplify(e2))
	end

	def simplify(e) do e end


	def simplify_add({:num, 0}, e2) do e2 end
	def simplify_add(e1, {:num, 0}) do e1 end
	def simplify_add({:num, n1}, {:num, n2}) do {:num, n1 + n2} end
	def simplify_add(e1, e2) do {:add, e1, e2} end

	def simplify_mul({:num, 0}, _) do {:num, 0} end
	def simplify_mul(_, {:num, 0}) do {:num, 0} end
	def simplify_mul({:num, 1}, e2) do e2 end
	def simplify_mul(e1, {:num, 1}) do e1 end
	def simplify_mul({:num, n1}, {:num, n2}) do {:num, n1 * n2} end
	def simplify_mul(e1, e2) do {:mul, e1, e2} end

	def simplify_exp(_, {:num, 0}) do {:num, 1} end
	def simplify_exp(e1, {:num, 1}) do e1 end
	def simplify_exp(e1, e2) do {:exp, e1, e2} end

	
	def simplify_sub(e1, {:num, 0}) do e1 end
	def simplify_sub({:num, 0}, e2) do {:mul, {:num, -1}, e2} end
	def simplify_sub({:num, n1}, {:num, n2}) do {:num, n1 - n2} end
	def simplify_sub(e1, e2) do {:sub, e1, e2} end

	def simplify_frac(e1, e2) do {:frac, e1, e2} end




	def pprint({:num, n}) do "#{n}" end
	def pprint({:var, v}) do "#{v}" end
	def pprint({:add, e1, e2}) do "(#{pprint(e1)} + #{pprint(e2)})" end
	def pprint({:mul, e1, e2}) do "#{pprint(e1)} * #{pprint(e2)}" end
	def pprint({:exp, e1, e2}) do "(#{pprint(e1)})(#{pprint(e2)})" end
	def pprint({:ln, e}) do "(ln(#{pprint(e)}))" end
	def pprint({:frac, e1, e2}) do "(#{pprint(e1)} / #{pprint(e2)})" end
	def pprint({:sub, e1, e2}) do "(#{pprint(e1)} - #{pprint(e2)})" end
	def pprint({:sqr, e}) do "√#{pprint(e)}" end
	def pprint({:sin, e}) do "sin(#{pprint(e)})" end
	def pprint({:cos, e}) do "cos(#{pprint(e)})" end


end