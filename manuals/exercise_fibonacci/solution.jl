function fib_last_digit(n::Integer)
    F = [0,1]
    for i in 3:n
        push!(F, mod(F[end-1] + F[end], 10))
    end 
    return F[end]
end

#::. solutions
fib_last_digit(10)
fib_last_digit(100)
fib_last_digit(1000)
fib_last_digit(10000)
