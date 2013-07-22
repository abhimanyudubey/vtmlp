function compile_process(image_name, model_name, output_path)
%Takes in a model path and image path, and evaluates the features.
	load image_name;
	im = imread(model_name);
	bbox = process(im, model, -0.5);
	save(output_path,'bbox');
end
