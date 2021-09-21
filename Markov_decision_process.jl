### A Pluto.jl notebook ###
# v0.14.8

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 5f9fed3a-685f-4e74-9418-c02caa129ee5
using PlutoUI

# ╔═╡ 89bac110-02d5-4a96-b66c-38f1057efd2c


# ╔═╡ 021d1db0-d573-11eb-39c3-b10c4228fa76
md"# Assignment 3"#

# ╔═╡ 0dc9bc54-e378-4977-9128-c8f53f81fae3
md"## Problem 1/Question 1"

# ╔═╡ 904ebe6b-a651-4413-9fd1-7ac837de7549
md"## Markov Decision Process"

# ╔═╡ 23fe0efc-c2ed-4259-b2ad-ed715f0da5fd
varinfo(PlutoUI)

# ╔═╡ 0b24688f-82de-4fa7-9f3c-c0da87c81cbf
begin
	c = 5
	d = 3
end

# ╔═╡ bda9a868-a20c-4950-936c-3a3b369bef1b


# ╔═╡ 791f91c1-996b-4c3c-8270-2c1a2177a6e3
S = collect(0:10)

# ╔═╡ 9c06bdad-8eea-468a-b4f1-9d264c6e615b
A = collect(0:10)

# ╔═╡ 6ef6041e-1889-473b-a2be-ec5650ef6506
typeof(A)

# ╔═╡ d55e5655-7c63-452e-9f85-106d8e3e2e51
States = Dict(S1=> "S1", S2 => "s2", S3 =>"s3")

# ╔═╡ 5a631e51-d6a0-47fb-b687-b8c4ecef9ef4
begin
	N = 10
	p = 0.4
end

# ╔═╡ 9c032182-b366-4236-b348-256813da4c30
function P(s_next, s, a)
	
	if s + a == s_next && a <= sum(s, N-s) && 0 < s < N
		return p
	elseif s - a == s_next && a <= sum(s, N-s) && 0 < s < N
		return (1 - p)
	else
		return 0
	end
end

# ╔═╡ 47ef9962-1123-436c-b08d-c894b692c4d0
function R(s, a)
	if s ==N
		return 1
	else
		return 0
	end
end

# ╔═╡ 69d8e50b-b1fa-4716-a502-520cc0cb5336
function policy_evaluation(policy, S)
	
	V = Dict(s => 1 for s in S)
	
	while true 
		oldV = copy(V)
		
		for s in S
			a = policy(s)
			V(s) = R(s,a) + sum(P(s_next, s, a) * oldV(s_next) for s_next in S)
			
			if all(oldV(s) == V(s)  for s in S)
				break
				return V
			end
		end
	end
end			

# ╔═╡ aa7f5d20-0e78-438a-b3f3-aea1842e7d67
function policy_improvement(V, S, A)
	
	policy = Dict(s => A[0] for s in S)
	
	for s in S
		Q = Dict()
		for a in A
			Q[a] = R(s,a) + sum(P(s_next, s,a) * V[s_next] for s_next in S)
			
			policy[s] = max(Q, key = Q.get)
			
			return policy
		end
	end
end

# ╔═╡ 6eb89678-08cc-4234-83f5-430741c3f9a6
function Policy_iteration(S, A, P, R)
	policy = Dict(s => A[1] for s in S)
		while true
			old_policy = copy(policy)
		
			V = policy_evaluation(policy, S)
		
			policy = policy_improvement(V,S,A)
		
			if all(old_policy[s] == policy[s] for s in S)
			
				break
				return policy
			end
		end
	end

# ╔═╡ 28f334ef-ce2c-4b6f-b477-252878d8a4d3
optimal_policy = Policy_iteration(S,A,P,R)

# ╔═╡ b5ddfeaa-168d-4e06-885d-916a769065c1
function see()
	if all(a==b)
		return true
	else
		return false
	end
end

# ╔═╡ a666b9be-7298-4563-98c5-b7c10d3631da
see()

# ╔═╡ 22b48431-2bb6-4763-94c9-1ac8f147e9fa
x = 0.9*0.5*10+0.1*0.5

# ╔═╡ 5b3cfc07-c94f-42a7-9199-8f3b6f652991
name = readline()

# ╔═╡ 925f87c5-58b5-4a7f-a5f4-c2c39d78326f
md"## Inputs"

# ╔═╡ 68e38813-3f48-4dae-84bb-3ebfb349c8f5
@bind states TextField()

# ╔═╡ 8959b9c5-4269-4d14-b691-b15410e5075f
St = Dict()

# ╔═╡ a726c28b-b49b-4eeb-ac1c-e7399df4a9e7
append!(St,states)

# ╔═╡ Cell order:
# ╠═89bac110-02d5-4a96-b66c-38f1057efd2c
# ╠═021d1db0-d573-11eb-39c3-b10c4228fa76
# ╠═0dc9bc54-e378-4977-9128-c8f53f81fae3
# ╠═904ebe6b-a651-4413-9fd1-7ac837de7549
# ╠═5f9fed3a-685f-4e74-9418-c02caa129ee5
# ╠═23fe0efc-c2ed-4259-b2ad-ed715f0da5fd
# ╠═6eb89678-08cc-4234-83f5-430741c3f9a6
# ╠═69d8e50b-b1fa-4716-a502-520cc0cb5336
# ╠═aa7f5d20-0e78-438a-b3f3-aea1842e7d67
# ╠═0b24688f-82de-4fa7-9f3c-c0da87c81cbf
# ╠═bda9a868-a20c-4950-936c-3a3b369bef1b
# ╠═791f91c1-996b-4c3c-8270-2c1a2177a6e3
# ╠═9c06bdad-8eea-468a-b4f1-9d264c6e615b
# ╠═6ef6041e-1889-473b-a2be-ec5650ef6506
# ╠═d55e5655-7c63-452e-9f85-106d8e3e2e51
# ╠═9c032182-b366-4236-b348-256813da4c30
# ╠═47ef9962-1123-436c-b08d-c894b692c4d0
# ╠═5a631e51-d6a0-47fb-b687-b8c4ecef9ef4
# ╠═28f334ef-ce2c-4b6f-b477-252878d8a4d3
# ╠═b5ddfeaa-168d-4e06-885d-916a769065c1
# ╠═a666b9be-7298-4563-98c5-b7c10d3631da
# ╠═22b48431-2bb6-4763-94c9-1ac8f147e9fa
# ╠═5b3cfc07-c94f-42a7-9199-8f3b6f652991
# ╠═925f87c5-58b5-4a7f-a5f4-c2c39d78326f
# ╠═68e38813-3f48-4dae-84bb-3ebfb349c8f5
# ╠═8959b9c5-4269-4d14-b691-b15410e5075f
# ╠═a726c28b-b49b-4eeb-ac1c-e7399df4a9e7
