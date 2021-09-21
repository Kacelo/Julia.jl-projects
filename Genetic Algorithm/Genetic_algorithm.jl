### A Pluto.jl notebook ###
# v0.14.8

using Markdown
using InteractiveUtils

# ╔═╡ 37e9662c-be2e-421c-9ced-63bfd3a4d6a4
md"## AIG Problem 1: Genetic Algorithm"

# ╔═╡ 44be83a2-e06f-11eb-066e-c38beb3d8c1d
function create_population(pop_size, pop_max)
	population = []
	for pop_counter in 1:pop_size
		push!(population, rand()*pop_max)
	end
	return population
end

# ╔═╡ e974bd70-5cef-4e90-a551-5e4a2238ba16
round(13.5+21+15)

# ╔═╡ e563bc6d-a980-4a0e-9440-8f46ad4d56aa
population = create_population(50, 1)

# ╔═╡ dad7adf8-9783-43f3-9f74-4f2d32fc318d
new=sort(population)

# ╔═╡ b2e52ab4-b586-408f-bc08-46f9290cc86b
new[new.>0.5]

# ╔═╡ 029c82d1-a609-495d-ac4d-f3af90c966c2
md"## Fitness Function"

# ╔═╡ 7f32fa7a-d7a9-46d0-a3cf-930116b73eed
function calculate_fitness(population)
	score = 0
	new  =0
	for i in eachindex(population)
		if population[i] > 0.5
			return fit_pop = population[population .> 0.5]
		end
	end
end

# ╔═╡ 4e44b0b2-3dae-4422-8e5c-cde94812467c
calculate_fitness(population)

# ╔═╡ c8448f60-a7ea-4102-867c-596692c46f11
population[1:5]

# ╔═╡ 70712fcf-be1f-48ac-b2dd-833f5a431be4
md"## Cross Over Function"

# ╔═╡ b96f3df8-d308-4e3d-9575-cb64a01a045c
function cross_over(parent1, parent2, crossover_point)
	offspring_partA = parent1[1:crossover_point]
	offspring_partB = parent2[crossover_point:end]
	return vcat(offspring_partA,offspring_partB)
end

# ╔═╡ 37af269a-68b9-45e4-82ec-12af4ebc3dd8
"## mutation"

# ╔═╡ 61f6fe45-32fb-41d0-8006-46fbce0409eb
function mutate(child, mutation_probability)
	new= map(x->round.(x), child)
	last = new[end,:]
	for i in eachindex(new)
		if i < mutation_probability
			i, last = last, i
			return new
		end
	end
end

# ╔═╡ f9da904d-1e85-4838-9e2b-9a5a1c55ffa3


# ╔═╡ e99ff06e-8956-427f-8f00-056f6dcb9ddc
md"## Genetic Algorithm"

# ╔═╡ 15190b9d-2c8e-4540-b05c-3022f04c86f6
function genetic_algorithm(population, calculate_fitness, iteration, crossover_point)
	for i in iteration
		fit_pop = calculate_fitness(population)
		p1 = rand(fit_pop)
        p2 = rand(fit_pop)
		child = cross_over(p1,p2, crossover_point)
		child = mutate(child)
		push!(population)
	end
end

# ╔═╡ f999d839-d72d-4706-b1bd-be3fb741ad9a
genetic_algorithm(population, calculate_fitness, 5, 30)

# ╔═╡ Cell order:
# ╠═37e9662c-be2e-421c-9ced-63bfd3a4d6a4
# ╠═44be83a2-e06f-11eb-066e-c38beb3d8c1d
# ╠═e974bd70-5cef-4e90-a551-5e4a2238ba16
# ╠═e563bc6d-a980-4a0e-9440-8f46ad4d56aa
# ╠═dad7adf8-9783-43f3-9f74-4f2d32fc318d
# ╠═b2e52ab4-b586-408f-bc08-46f9290cc86b
# ╠═029c82d1-a609-495d-ac4d-f3af90c966c2
# ╠═7f32fa7a-d7a9-46d0-a3cf-930116b73eed
# ╠═4e44b0b2-3dae-4422-8e5c-cde94812467c
# ╠═c8448f60-a7ea-4102-867c-596692c46f11
# ╠═70712fcf-be1f-48ac-b2dd-833f5a431be4
# ╠═b96f3df8-d308-4e3d-9575-cb64a01a045c
# ╠═37af269a-68b9-45e4-82ec-12af4ebc3dd8
# ╠═61f6fe45-32fb-41d0-8006-46fbce0409eb
# ╠═f9da904d-1e85-4838-9e2b-9a5a1c55ffa3
# ╠═e99ff06e-8956-427f-8f00-056f6dcb9ddc
# ╠═15190b9d-2c8e-4540-b05c-3022f04c86f6
# ╠═f999d839-d72d-4706-b1bd-be3fb741ad9a
