import numpy as np
from flask import Flask, request, jsonify
from flask_cors import CORS
import pickle
import pandas as pd
import json

app = Flask(__name__)
CORS(app)

# model = pickle.load(open('./models/model.pkl', 'rb'))


@app.route("/", methods=['GET'])
def index():
    return "Hello World."


class NpEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, np.integer):
            return int(obj)
        if isinstance(obj, np.floating):
            return float(obj)
        if isinstance(obj, np.ndarray):
            return obj.tolist()
        return json.JSONEncoder.default(self, obj)


def encode(course):
    course2Id, id2Course = pickle.load(open('./course.pkl', 'rb'))
    return course2Id[course]


@app.route('/api/predict', methods=['POST'])
def predict():
    print("Hi")
    data = request.get_json()
    columns = ['Choose your gender', 'Age',
               'What is your course?', 'Your current year of Study', 'What is your CGPA?', 'Marital status', 'Do you have Anxiety?', 'Do you have Panic attack?', 'Did you seek any specialist for a treatment?']
    df = pd.DataFrame(data, index=[0], columns=columns)
    df['What is your course?'] = df['What is your course?'].apply(
        lambda x: encode(x))

    model = pickle.load(open('./model.pkl', 'rb'))
    output = model.predict(df)
    return app.response_class(
        response=json.dumps({
            "predict": output[0],
        }, cls=NpEncoder),
        status=200,
        mimetype='application/json'
    )


if __name__ == '__main__':
    app.run(debug=False)
