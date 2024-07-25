// from flask import Flask, request, jsonify
// from transformers import pipeline

// app = Flask(__name__)

// # Load the sentiment analysis pipeline
// sentiment_analysis = pipeline("sentiment-analysis")

// @app.route('/')
// def home():
//     return "Welcome to the Sentiment Analysis API!"

// @app.route('/analyze', methods=['POST'])
// def predict():
//     if not request.json or 'feedback' not in request.json:
//         return jsonify({'error': 'Invalid input'}), 400
    
//     feedback = request.json['feedback']
    
//     # Perform sentiment analysis
//     result = sentiment_analysis(feedback)[0]
    
//     response = {
//         'label': result['label'],
//         'score': result['score']
//     }
    
//     return jsonify(response)

// if __name__ == '__main__':
//     app.run(debug=True)
