// from flask import Flask, request, jsonify
// import requests
// from bs4 import BeautifulSoup
// from transformers import pipeline

// app = Flask(__name__)

// # Load the sentiment-analysis pipeline
// sentiment_analyzer = pipeline("sentiment-analysis")

// def fetch_reviews(url):
//     # You may need to adjust this function based on the specific HTML structure of the product page.
//     response = requests.get(url)
//     soup = BeautifulSoup(response.content, 'html.parser')
    
//     # Example: Adjust the selector according to the actual review element in the HTML
//     reviews = soup.select('.review-data')  # Update the selector as needed
//     return [review.get_text() for review in reviews]

// @app.route('/url-analyze', methods=['POST'])
// def analyze_sentiment():
//     data = request.json
//     url = data.get('url')

//     if not url:
//         return jsonify({"error": "URL is required"}), 400

//     try:
//         reviews = fetch_reviews(url)
//         sentiments = sentiment_analyzer(reviews)

//         positive_count = sum(1 for sentiment in sentiments if sentiment['label'] == 'POSITIVE')
//         negative_count = sum(1 for sentiment in sentiments if sentiment['label'] == 'NEGATIVE')
//         neutral_count = sum(1 for sentiment in sentiments if sentiment['label'] == 'NEUTRAL')

//         return jsonify({
//             "positive_count": positive_count,
//             "negative_count": negative_count,
//             "neutral_count": neutral_count
//         })

//     except Exception as e:
//         return jsonify({"error": str(e)}), 500

// if __name__ == '__main__':
//     app.run(debug=True)
