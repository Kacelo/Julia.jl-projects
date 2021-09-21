### A Pluto.jl notebook ###
# v0.14.5

using Markdown
using InteractiveUtils

# ╔═╡ 7ce3d260-d17b-11eb-26f6-1f052277e962
using Pkg;

# ╔═╡ 1a69e6af-ee96-486c-8050-9e2b531df21d
Pkg.add("MLDataUtils")

# ╔═╡ d06f2f65-5ae6-4528-b520-57d7d3a70dff
using Printf

# ╔═╡ 18ab5129-47eb-4550-a842-a285516eb6a1
using Flux:@epochs

# ╔═╡ 5b7eaea8-7390-4993-b96e-489201dafc3a
using DataFrames

# ╔═╡ 4793ca61-d122-4ccc-ba7e-dca352869ea0
using FileIO

# ╔═╡ 424688ea-3ae5-45c1-a65b-dc485682d178
using CSV

# ╔═╡ 222c5c16-fc96-445d-bf00-7266cecac930
using Images

# ╔═╡ cb508400-bb0c-4263-aaae-fd9c55b9705f
using Colors

# ╔═╡ fe42977f-0aae-4afb-9522-36335ddf0942
using ImageIO

# ╔═╡ 60cbcaa9-7d7d-4dab-886e-202769303766
using Flux

# ╔═╡ 2ca4c1ea-a926-4088-8bae-5fd6807d6bb6
using Flux: onehotbatch, onecold

# ╔═╡ 1f27be6a-a162-4bbb-9202-a9b2caa40af6
using Flux.Losses: logitcrossentropy

# ╔═╡ 5fd51445-e1cb-4b91-bb80-df4fcdbc0e01
using Plots

# ╔═╡ 84ab744c-2898-421c-9805-b8d7df5b221f
md"##### Importing all packages needed for Data Preprocessing"

# ╔═╡ 0f614528-71a2-426f-80f6-3d764848d39b
pwd()

# ╔═╡ 7329e0a8-0400-4d1e-a0a8-6a67152f3fec
md"#### Data Preprocessing"

# ╔═╡ f0f21eb6-ca22-44ca-892b-c6c23f19b2c6
md"##### Data Paths to be used"

# ╔═╡ 9179d0ba-5e23-4d6f-b307-ca44923c4153
dir = "C:/Users/Katukula/Downloads/chest_xray"

# ╔═╡ a36df600-f22a-42a3-bb29-e970d8e4f67d
train_norm = "C:/Users/Katukula/Downloads/chest_xray/train/\\NORMAL"

# ╔═╡ 0ab84385-0fdc-48e1-a8e2-4bbc2b0a730b
train_pneu = "C:/Users/Katukula/Downloads/chest_xray/train/\\PNEUMONIA"

# ╔═╡ 5dbf2136-0103-4b7b-a19f-e974fcde7c45
test_norm = "C:/Users/Katukula/Downloads/chest_xray/test/\\NORMAL"

# ╔═╡ 32633648-b4f9-47e0-8cc0-d95c6ef3debb
test_pneu = "C:/Users/Katukula/Downloads/chest_xray/test/\\PNEUMONIA"

# ╔═╡ 148c0fc9-7e39-4db0-8c5f-6540195cb957


# ╔═╡ 2dfc8245-0dd2-44bc-a8d7-66108c1ed961
md"### Data Preperation"

# ╔═╡ 7b8b2273-18ab-4f85-91cc-f08d8e673a26
const IMAGE_SIZE = 28

# ╔═╡ 79a5ef8d-868a-4140-ad8d-9986d342bf89
"""Function to resize images and to apply a gray scale to reduce the need to process all the channels of colour images, which have 3 channels compared to grayscale images that only have one"""

# ╔═╡ 4b8a3a0b-f493-4346-8b16-f02e95343629
function resize_grayscale(main_path, im_name, w::Int64, h::Int64)
	processed_img = Gray.(load(main_path*"\\"*im_name)) |>(x-> imresize(x, w,h))
	try
		save("preprocessed_"*main_path* "\\"* im_name, processed_img)
		
	catch e
		if isa(e, SystemError)
			mkdir("preprocessed_"*main_path)
			save("preprocessed_"* main_path*"\\"* im_name, processed_img)
		end
	end
end

# ╔═╡ 2060e474-fae3-4f23-a402-e9e46e59daab
#function to take the main directory path and its contents and pass it to the function that changes image size and image color

# ╔═╡ 9b53ce0e-5249-4903-8161-6d5b209356d0
function process_imgs(main_path, w::Int64, h::Int64)
	files_list = readdir(main_path)
	map(x -> resize_grayscale(main_path, x, w, h), files_list)
end

# ╔═╡ a4885583-08a4-4490-98f7-c438ca8d105d
begin 
	normal_trainf = readdir("C:/Users/Katukula/Downloads/chest_xray/train/\\NORMAL\\")
	pneumonia_trainf = readdir("C:/Users/Katukula/Downloads/chest_xray/train/\\PNEUMONIA\\")
	path_norm = "C:/Users/Katukula/Downloads/chest_xray/train/\\NORMAL\\".*normal_trainf
	path_neum = "C:/Users/Katukula/Downloads/chest_xray/train/\\PNEUMONIA\\".*pneumonia_trainf
	img_paths = [path_norm; path_neum]
end

# ╔═╡ e4d01a67-0b20-4009-855a-511a89d5c13d
function process_normal_test()
	image = (img_paths)
	image = Gray.(image)
	image = imresize(image,(28,28))
	try
		save("preprocessed_"*train_norm, image)
	catch e
		if isa(e, SystemError)
			mkdir("preprocessed_"*train_norm)
			save("preprocessed_"*train_norm, image)
		end
	end
end

# ╔═╡ 997487d3-590e-4751-8df4-06d219e44774
begin 
	process_imgs(train_norm, IMAGE_SIZE, IMAGE_SIZE)
	process_imgs(train_pneu, IMAGE_SIZE, IMAGE_SIZE)
	process_imgs(test_norm, IMAGE_SIZE, IMAGE_SIZE)
	process_imgs(test_pneu, IMAGE_SIZE, IMAGE_SIZE)
end

# ╔═╡ 63a2154b-7a47-4c6d-9ddf-ea78005fe463
function process_image(path)
	img = load(path)
	img =Gray.(img)
	img = imresize(img,(IMAGE_SIZE, IMAGE_SIZE))
	img = vec(img)
	img = convert(Array{Float32,1},img)
	return img
end

# ╔═╡ f3266c78-d652-4295-8f50-0add79e09198
function proc_image(path)
	img = load(path)
	img =Gray.(img)
	img = imresize(img,(IMAGE_SIZE, IMAGE_SIZE))
	
	return img
end

# ╔═╡ 676605b8-43b4-4f31-9599-9fc8c2e981f4


# ╔═╡ b5a64d33-81a7-47c0-a68a-f0b92a4bf764
begin
	normal_train_dir = readdir("C:/Users/Katukula/Downloads/chest_xray/train/\\NORMAL\\")
	pneumonia_train_dir = readdir("C:/Users/Katukula/Downloads/chest_xray/train/\\PNEUMONIA\\")
	normal_test_dir = readdir("C:/Users/Katukula/Downloads/chest_xray/test/\\NORMAL\\")
	pneumonia_test_dir = readdir("C:/Users/Katukula/Downloads/chest_xray/test/\\PNEUMONIA\\")
end
	

# ╔═╡ b8b34a58-e610-45a7-8f15-39ed84711900
begin 
	normal_imgs = load.("C:/Users/Katukula/Downloads/chest_xray/train/\\NORMAL\\".*normal_train_dir)
	pneumonia_imgs= load.("C:/Users/Katukula/Downloads/chest_xray/train/\\PNEUMONIA\\".*pneumonia_train_dir)
	normal_imgs_test = load.("C:/Users/Katukula/Downloads/chest_xray/train/\\NORMAL\\".*normal_test_dir)
	pneumonia_imgs_test= load.("C:/Users/Katukula/Downloads/chest_xray/train/\\PNEUMONIA\\".*pneumonia_test_dir)
end

# ╔═╡ dcc79292-bb52-480a-b818-4b408cc6f725
normal = vcat(normal_imgs, normal_imgs_test)

# ╔═╡ b7f9ba97-b15d-4ec6-b2e8-9bdf98497583
pneumonia =(pneumonia_imgs, pneumonia_imgs_test)

# ╔═╡ ba38988e-0533-48d4-858c-11c8d7085dc8
data = vcat(normal, pneumonia)

# ╔═╡ 466ba69e-2a21-4485-92b1-73050bc4789b
begin 
	labels = vcat[0 for _ in 1:length(normal)], [1 for _ in 1:length(pneumonia)]
	 (x_train, y_train), (x_test, y_test) = splitobs(shuffleobs((data, labels)), at = 0.7)
end;

# ╔═╡ 1818da26-3890-4fae-b0f9-af5b8b96ffcc
md"### importing all needed packages to create the Neural Network"

# ╔═╡ 9835d834-c9a0-4304-bbcf-38f17825ccd0
function mini_batch(X, Y, idxs)
	
	X_batch = Array{Float32}(undef, size(X[1])...,1, length(idxs))
	
	for i in 1:length(idxs)
		
		X_batch[:,:,:,i] = Float32.(X[idxs[i]])
		
	end
	Y_batch = onehotbatch(Y[idxs], 0:1)
	
	return(X_batch, Y_batch)
end

# ╔═╡ a85f6797-0dd4-438b-b7d2-e3da91044c32
begin
	batchsize = 128
	mb_idxs = partition(1:length(x_train), batchsize)
	train_set = [mini_batch(x_train, y_train, i) for i in mb_idxs]
	test_set = make_minibatch(x_test, y_test, 1:length(x_test))
end

# ╔═╡ 9c86ab82-2319-4bcf-9769-5a209ca68193
md"## Fully Connected LeNet 5"

# ╔═╡ a50d17b5-e2b9-41e6-86df-15486da1cb25
function LeNet5(; image = (28,28,1), nclasses = 2)
	out_conv_size = (imagesize[1]/4-3, imagesize[2]/4-3,16)
	
	return Chain(	
		Conv((5,5), imgsize[end]=>6, pad=(1,1), relu),
		
		MaxPool((2,2)),
		
		Conv((5,5),6=>16, pad=(1,1), relu),
		
		MaxPool((2,2)),
		
		flatten,
		
		Dense(prod(out_con_size), 120, relu),
		
		Dense(120,84,relu),
		
		Dense(84, nclasses),
		
		softmax
	)
end

# ╔═╡ fa5a4844-a2f4-42eb-8ad0-969d426dd4fd
##mini batch for test

# ╔═╡ bc5f5ffc-eca4-416b-a529-6cb4722e3996
begin
    train_loss = Float64[]
    test_loss = Float64[]
    acc = Float64[]
	model = LeNet5()
    ps = Flux.params(model)
    opt = ADAM(0.001)
    L(x, y) = Flux.crossentropy(model(x), y)
    L((x,y)) = Flux.crossentropy(model(x), y)
    accuracy(x, y, f) = mean(Flux.onecold(f(x)) .== Flux.onecold(y))
    
    function update_loss!()
        push!(train_loss, mean(L.(train_set)))
        push!(test_loss, mean(L(test_set)))
        push!(acc, accuracy(test_set..., model))
        @printf("train loss = %.2f, test loss = %.2f, accuracy = %.2f\n", train_loss[end], test_loss[end], acc[end])
    end
end

# ╔═╡ 928d0c35-d4e8-4804-b856-13b3753be85b


# ╔═╡ 90ac78a0-e8cd-4c21-821d-c17aab9b6ea1


# ╔═╡ 7bf627d7-6d10-48af-8f22-a2e206fcb60c


# ╔═╡ Cell order:
# ╠═84ab744c-2898-421c-9805-b8d7df5b221f
# ╠═7ce3d260-d17b-11eb-26f6-1f052277e962
# ╠═d06f2f65-5ae6-4528-b520-57d7d3a70dff
# ╠═18ab5129-47eb-4550-a842-a285516eb6a1
# ╠═5b7eaea8-7390-4993-b96e-489201dafc3a
# ╠═4793ca61-d122-4ccc-ba7e-dca352869ea0
# ╠═424688ea-3ae5-45c1-a65b-dc485682d178
# ╠═222c5c16-fc96-445d-bf00-7266cecac930
# ╠═cb508400-bb0c-4263-aaae-fd9c55b9705f
# ╠═fe42977f-0aae-4afb-9522-36335ddf0942
# ╠═1a69e6af-ee96-486c-8050-9e2b531df21d
# ╠═0f614528-71a2-426f-80f6-3d764848d39b
# ╠═7329e0a8-0400-4d1e-a0a8-6a67152f3fec
# ╠═f0f21eb6-ca22-44ca-892b-c6c23f19b2c6
# ╠═9179d0ba-5e23-4d6f-b307-ca44923c4153
# ╠═a36df600-f22a-42a3-bb29-e970d8e4f67d
# ╠═0ab84385-0fdc-48e1-a8e2-4bbc2b0a730b
# ╠═5dbf2136-0103-4b7b-a19f-e974fcde7c45
# ╠═32633648-b4f9-47e0-8cc0-d95c6ef3debb
# ╠═148c0fc9-7e39-4db0-8c5f-6540195cb957
# ╠═2dfc8245-0dd2-44bc-a8d7-66108c1ed961
# ╠═7b8b2273-18ab-4f85-91cc-f08d8e673a26
# ╠═79a5ef8d-868a-4140-ad8d-9986d342bf89
# ╠═4b8a3a0b-f493-4346-8b16-f02e95343629
# ╠═2060e474-fae3-4f23-a402-e9e46e59daab
# ╠═9b53ce0e-5249-4903-8161-6d5b209356d0
# ╠═a4885583-08a4-4490-98f7-c438ca8d105d
# ╠═e4d01a67-0b20-4009-855a-511a89d5c13d
# ╠═997487d3-590e-4751-8df4-06d219e44774
# ╠═63a2154b-7a47-4c6d-9ddf-ea78005fe463
# ╠═f3266c78-d652-4295-8f50-0add79e09198
# ╠═676605b8-43b4-4f31-9599-9fc8c2e981f4
# ╠═b5a64d33-81a7-47c0-a68a-f0b92a4bf764
# ╠═b8b34a58-e610-45a7-8f15-39ed84711900
# ╠═dcc79292-bb52-480a-b818-4b408cc6f725
# ╠═b7f9ba97-b15d-4ec6-b2e8-9bdf98497583
# ╠═ba38988e-0533-48d4-858c-11c8d7085dc8
# ╠═466ba69e-2a21-4485-92b1-73050bc4789b
# ╠═1818da26-3890-4fae-b0f9-af5b8b96ffcc
# ╠═60cbcaa9-7d7d-4dab-886e-202769303766
# ╠═2ca4c1ea-a926-4088-8bae-5fd6807d6bb6
# ╠═1f27be6a-a162-4bbb-9202-a9b2caa40af6
# ╠═5fd51445-e1cb-4b91-bb80-df4fcdbc0e01
# ╠═9835d834-c9a0-4304-bbcf-38f17825ccd0
# ╠═a85f6797-0dd4-438b-b7d2-e3da91044c32
# ╠═9c86ab82-2319-4bcf-9769-5a209ca68193
# ╠═a50d17b5-e2b9-41e6-86df-15486da1cb25
# ╠═fa5a4844-a2f4-42eb-8ad0-969d426dd4fd
# ╠═bc5f5ffc-eca4-416b-a529-6cb4722e3996
# ╠═928d0c35-d4e8-4804-b856-13b3753be85b
# ╠═90ac78a0-e8cd-4c21-821d-c17aab9b6ea1
# ╠═7bf627d7-6d10-48af-8f22-a2e206fcb60c
