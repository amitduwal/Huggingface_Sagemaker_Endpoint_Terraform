from FlagEmbedding import FlagModel
import torch
import json
from json import JSONEncoder
import numpy


class NumpyArrayEncoder(JSONEncoder):
    def default(self, obj):
        if isinstance(obj, numpy.ndarray):
            return obj.tolist()
        return JSONEncoder.default(self, obj)


JSON_CONTENT_TYPE = 'application/json'


def model_fn(model_dir):
    """
    Create and return an instance of the INSTRUCTOR model.

    Parameters:
    model_dir (str): The directory where the model artifacts are stored.

    Returns:
    model: An instance of the INSTRUCTOR model.
    
    """
    model = FlagModel(model_dir)
    return model


def input_fn(serialized_input_data, content_type=JSON_CONTENT_TYPE):
    """
    Parse the serialized input data and return it as a Python data structure.

    Parameters:
    serialized_input_data (str): serialized input data, typically in JSON format.
    content_type (str): content type of the serialized input data (default:'application/json').

    Returns:
    input_data: deserialized input data as a Python data structure.

    Raises:
    Exception: If the requested content type is not supported.
    
    """    
    if content_type == JSON_CONTENT_TYPE:
        input_data = json.loads(serialized_input_data)
        return input_data

    else:
        raise Exception('Requested unsupported ContentType in Accept: ' + content_type)
        return


def predict_fn(input_data, model):
    """
    Encode input data using the provided model.

    Parameters:
    input_data: The input data to be encoded.
    model: The model used for encoding.

    Returns:
    encoded_data: The encoded representation of the input data.
    
    """
    
    print('Got input Data: {}'.format(input_data))
    return model.encode(input_data)


def output_fn(prediction_output, accept=JSON_CONTENT_TYPE):
    """
    Serialize the prediction output and prepare it for response.

    Parameters:
    prediction_output: The output of the prediction, typically a NumPy array.
    accept (str): The content type for the response (default: 'application/json').

    Returns:
    response: A dictionary containing the serialized prediction output.
    
    """
    # Serialization
    numpyData = {"array": prediction_output}
    encodedNumpyData = json.dumps(numpyData, cls=NumpyArrayEncoder) # use dump() to write array into file
#     print("Printing JSON serialized NumPy array")
#     print(encodedNumpyData)
#     print(f"Prediction output: {prediction_output}")
    return {
        "embedding": encodedNumpyData
    }
    