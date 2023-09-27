import os
import json
from json import JSONEncoder
import torch
import numpy
from transformers import AutoTokenizer, AutoModel

# os.environ["CUDA_VISIBLE_DEVICES"] = "" 


class NumpyArrayEncoder(JSONEncoder):
    def default(self, obj):
        if isinstance(obj, numpy.ndarray):
            return obj.tolist()
        return JSONEncoder.default(self, obj)


JSON_CONTENT_TYPE = 'application/json'


def model_fn(model_dir):
    tokenizer = AutoTokenizer.from_pretrained(model_dir)
    model = AutoModel.from_pretrained(model_dir)
    return model, tokenizer


def input_fn(serialized_input_data, content_type=JSON_CONTENT_TYPE):  
    if content_type == JSON_CONTENT_TYPE:
        input_data = json.loads(serialized_input_data)
        return input_data

    else:
        raise Exception('Requested unsupported ContentType in Accept: ' + content_type)


def predict_fn(input_data, model_and_tokenizer):
    print('Got input Data::')
    print(input_data)
    model, tokenizer = model_and_tokenizer
    model.eval()
    
    # Tokenize sentences
    encoded_input = tokenizer(input_data, padding=True, truncation=True, return_tensors='pt')

    # Compute token embeddings
    with torch.no_grad():
        model_output = model(**encoded_input)
        # Perform pooling. In this case, cls pooling.
        sentence_embeddings = model_output[0][:, 0]
        sentence_embeddings = torch.nn.functional.normalize(sentence_embeddings, p=2, dim=1)

    return sentence_embeddings.tolist()


def output_fn(prediction_output, accept=JSON_CONTENT_TYPE):
    print('Got output Data::')
    print(prediction_output)
    return {
        "embedding": json.dumps(prediction_output, cls=NumpyArrayEncoder)
    }