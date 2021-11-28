### A Pluto.jl notebook ###
# v0.14.8

using Markdown
using InteractiveUtils

# ╔═╡ c6e8216e-9b0c-436e-b997-1058e6dfe556
using Pkg;

# ╔═╡ 34551668-5b0a-4637-9097-3675d4525945
Pkg.activate("Project.toml")

# ╔═╡ f860c861-3aa1-40c4-8a45-7e135ba5f3ea
using InteractiveUtils

# ╔═╡ 2a97a57e-e07c-11eb-1ce1-4deb97b54a99
md"## Constraint Satisfaction"

# ╔═╡ 043f420d-a30e-48d7-8c07-7a64fc4504cd
@enum numDomain one two three four

# ╔═╡ 3940b24e-e76c-4363-a92c-e919d00328e0
mutable struct Variables
	name::String
	value::Union{Nothing, numDomain}
	not_allowed::Vector{numDomain}
	domain_restriction_count::Int64
end

# ╔═╡ 6461cb71-7e4f-48a6-8541-0133dfdc21a5
struct numberCSP
	var::Vector{Variables}
	constraints::Vector{Tuple{Variables,Variables}}
end

# ╔═╡ 9134f13b-950d-49d8-951f-c57859bdc350


# ╔═╡ d6ed06d2-3eca-48f3-9b9a-40ce8c0e4124
function solve_csp(pb::numberCSP, all_assignments)
	for current_var in pb.var
		if current_var.domain_restriction_count==4
			return []
		else
			next_val = rand(setdiff(Set([one,two,three,four]), Set(current_var.not_allowed)))
			
			for current_constraint in pb.constraints
				if !((current_constraint[1] == current_var) || (current_constraint[2] == current_var))
					continue
				else
					if current_constraint[1]==current_var
						push!(current_constraint[2].not_allowed, next_val)
						current_constraint[2].domain_restriction_count +=1
					else
						push!(current_constraint[1].not_allowed, next_val)
						current_constraint[1].domain_restriction_count +=1
					end
				end
			end
			push!(all_assignments, current_var.name=>next_val)
		end
	end
	return all_assignments
end



# ╔═╡ e5dd0839-fc83-4f7e-9d1e-e7cc0ce72137
## add foward checking

# ╔═╡ e45aaadb-e15a-4471-bb5d-a98a151a92cf
md"### backtrack search function"

# ╔═╡ 76c602e2-b8b0-474f-9c09-fa7e0f5be23b
md"### backtrack function"

# ╔═╡ 637960c0-270a-4e97-ad8a-5deb4d7c89c8
function inference(pb::numberCSP, current_variable)
end

# ╔═╡ 915c489c-d272-4fc0-8735-2c9ac339cf5a
function backtrack(pb::numberCSP, all_assignments)
	for current_variable in pb.var
		if current_variable.domain_restriction_count ==4
			return all_assignments
		else
	next_val = rand(setdiff(Set([one,two,three,four]), Set(current_variable.not_allowed)))
			
			for current_constraint in pb.constraints
				if !((current_constraint[1] == current_variable) || (current_constraint[2] == current_variable))
					
			if current_constraint[1]==current_variable
			   push!(current_constraint[2].not_allowed, next_val)
			   current_constraint[2].domain_restriction_count +=1
				else
						
				push!(current_constraint[1].not_allowed, next_val)
				current_constraint[1].domain_restriction_count +=1
					end
					push!(all_assignments, current_variable.name=>next_val)
				end
				inferences = inference(pb::numberCSP, current_variable)
				if inferences != 0
					push!(all_assignments, inferences)
				else
					result = backtrack(pb, all_assignments)
				if result !=0
					return result
					pop!(all_assignments, inferences,current_variable.name=>next_val)
					return false
					end
				end
			end
		end
	end
end

# ╔═╡ 22a9dc20-75ba-4051-bf2d-49270851e6fc
function backtracking_search(pb::numberCSP)
	return backtrack(pb::numberCSP, all_assignments)
end

# ╔═╡ 7ecccb66-603c-4fd6-8c23-251600f3af2e
md"#### backtrack algorithm at work"

# ╔═╡ dc4a3549-1b7f-4f7c-870c-de8bbd63cba0
md"### Forward Checking Algorithm"

# ╔═╡ fcb58c33-4ca5-4589-8741-5d1a2c538f1e
function forward_check(pb::numberCSP, current_var)
	for current_constraint in pb.constraints
		if !((current_constraint[1] == current_var) || (current_constraint[2] == current_var))
			pop!(current_constraint[2], current_var)
		end
	end
	if (length(pb.current_domain_restriction==0))
		return false
	end
end
	

# ╔═╡ c8b77c7f-feed-468b-a504-c3f6d2ed5a3e
x1 = Variables("x1",nothing,[],0)

# ╔═╡ 78491ebb-4e31-401a-a58b-d94c21ed471a
x2 = Variables("x2",nothing,[],0)

# ╔═╡ 308ddf80-50df-43ce-9572-dbb528a54de5
x3 = Variables("x3",nothing,[four,three,two],0)

# ╔═╡ d1cc53e1-78a9-49a2-9e0a-e0e298f59ba6
x4 = Variables("x4",nothing,[],0)

# ╔═╡ a6cd12f5-88a9-46a6-8493-e3bf173a68f1
x5 = Variables("x5",nothing,[],0)

# ╔═╡ d787e5ab-b288-4f36-bd23-1ffb6e145317
x6 = Variables("x6",nothing,[],0)

# ╔═╡ 820974b8-0c60-4537-a845-88e05f791e75
x7 = Variables("x7",nothing,[],0)

# ╔═╡ b08566f4-2062-44cc-b91a-502374502840
problem = numberCSP([x1,x2,x3,x4,x5,x6,x7], [(x1,x2),(x1,x3),(x1,x4),(x1,x5),(x1,x6),(x2,x5),(x3,x4),(x4,x5),(x4,x6),(x5,x6),(x6,x7)])

# ╔═╡ b7f1f0b8-6d3c-484c-bcec-6a9f4e11f374
backtrack(problem,[])

# ╔═╡ 1b0a5396-4e27-443b-91ba-65a428690ae1
forward_check(problem, x1)

# ╔═╡ d9d8d52c-724b-4685-a78a-e48ed07e303b
solve_csp(problem,[])

# ╔═╡ Cell order:
# ╠═2a97a57e-e07c-11eb-1ce1-4deb97b54a99
# ╠═c6e8216e-9b0c-436e-b997-1058e6dfe556
# ╠═34551668-5b0a-4637-9097-3675d4525945
# ╠═f860c861-3aa1-40c4-8a45-7e135ba5f3ea
# ╠═043f420d-a30e-48d7-8c07-7a64fc4504cd
# ╠═3940b24e-e76c-4363-a92c-e919d00328e0
# ╠═6461cb71-7e4f-48a6-8541-0133dfdc21a5
# ╠═9134f13b-950d-49d8-951f-c57859bdc350
# ╠═d6ed06d2-3eca-48f3-9b9a-40ce8c0e4124
# ╠═e5dd0839-fc83-4f7e-9d1e-e7cc0ce72137
# ╠═e45aaadb-e15a-4471-bb5d-a98a151a92cf
# ╠═22a9dc20-75ba-4051-bf2d-49270851e6fc
# ╠═76c602e2-b8b0-474f-9c09-fa7e0f5be23b
# ╠═915c489c-d272-4fc0-8735-2c9ac339cf5a
# ╠═637960c0-270a-4e97-ad8a-5deb4d7c89c8
# ╠═7ecccb66-603c-4fd6-8c23-251600f3af2e
# ╠═b7f1f0b8-6d3c-484c-bcec-6a9f4e11f374
# ╠═dc4a3549-1b7f-4f7c-870c-de8bbd63cba0
# ╠═fcb58c33-4ca5-4589-8741-5d1a2c538f1e
# ╠═1b0a5396-4e27-443b-91ba-65a428690ae1
# ╠═c8b77c7f-feed-468b-a504-c3f6d2ed5a3e
# ╠═78491ebb-4e31-401a-a58b-d94c21ed471a
# ╠═308ddf80-50df-43ce-9572-dbb528a54de5
# ╠═d1cc53e1-78a9-49a2-9e0a-e0e298f59ba6
# ╠═a6cd12f5-88a9-46a6-8493-e3bf173a68f1
# ╠═d787e5ab-b288-4f36-bd23-1ffb6e145317
# ╠═820974b8-0c60-4537-a845-88e05f791e75
# ╠═b08566f4-2062-44cc-b91a-502374502840
# ╠═d9d8d52c-724b-4685-a78a-e48ed07e303b
