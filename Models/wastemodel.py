import pickle
from skimage import io, color, transform, metrics
import numpy as np
from keras.preprocessing import image
from keras.applications.inception_v3 import InceptionV3, preprocess_input, decode_predictions

def resize_image(image, target_shape=(256, 256)):
    return transform.resize(image, target_shape, mode='reflect', anti_aliasing=True)

def convert_to_grayscale(image):
    if len(image.shape) > 2 and image.shape[2] == 4:  # Check for RGBA format
        return color.rgb2gray(image[:, :, :3])  # Exclude alpha channel
    else:
        return color.rgb2gray(image)

def preprocess_image(img_path):
    # Load and preprocess the image for the InceptionV3 model
    img = image.load_img(img_path, target_size=(299, 299))
    img_array = image.img_to_array(img)
    img_array = np.expand_dims(img_array, axis=0)
    img_array = preprocess_input(img_array)
    return img_array

def classify_image(model, img_array):
    # Classify the image using the InceptionV3 model
    predictions = model.predict(img_array)
    decoded_predictions = decode_predictions(predictions)
    return decoded_predictions

def has_waste(predictions):
    # Check if the predictions contain a class related to waste or litter
    for _, label, _ in predictions[0]:
        if 'trash' in label.lower() or 'litter' in label.lower():
            return True
    return False

def is_waste_material(predictions):
    # Check if the predictions contain waste materials
    waste_materials = ["plastic_bag", "conch", "water_bottle", "fiddler_crab", "beer_can", "pop_bottle", "wrapper",
                       "traffic_light", "fire_hydrant", "traffic_sign", "syringe", "tire", "radiator", "car_wheel"]
    for _, label, confidence in predictions[0]:
        if label in waste_materials and confidence >= 0.15:  # Adjust confidence threshold as needed
            return True
    return False

def process_images(image1_path, image2_path, image3_path):
    # Load and resize images to a common size
    target_shape = (256, 256)
    image1 = resize_image(io.imread(image1_path), target_shape)
    image2 = resize_image(io.imread(image2_path), target_shape)
    image3 = resize_image(io.imread(image3_path), target_shape)

    # Convert images to grayscale
    image1 = convert_to_grayscale(image1)
    image2 = convert_to_grayscale(image2)
    image3 = convert_to_grayscale(image3)

    # Compare images
    similarity1_2 = metrics.structural_similarity(image1, image2)
    similarity2_3 = metrics.structural_similarity(image2, image3)
    similarity1_3 = metrics.structural_similarity(image1, image3)


    # Check if any pair has similarity greater than or equal to the threshold
    if similarity1_2 >= 0.4 and similarity2_3 >= 0.4 and similarity1_3 >= 0.4:
        # print('here')
        # Load InceptionV3 model
        inception_model = InceptionV3(weights='imagenet')

        # Preprocess image 2
        img_array = preprocess_image(image2_path)

        # Classify the image
        predictions = classify_image(inception_model, img_array)
        # print(predictions)
        # Check if the image contains waste or litter
        contains_waste = is_waste_material(predictions)

        return contains_waste
    else:
        return False

# Save the function along with its dependencies to a pickle file
output_file_path = "process_images_function1.pkl"
with open(output_file_path, 'wb') as file:
    pickle.dump(process_images, file)
