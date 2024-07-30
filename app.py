from flask import Flask, Response, jsonify
import pandas as pd

app = Flask(__name__)
csv = 'dataset/StudentsPerformance.csv'

#route to csv at 127.0.0.1:5000/csvdata
@app.route('/csvdata', methods=['GET'])
def get_csv_data():
    # Load your CSV file
    df = pd.read_csv(csv)
    # Convert DataFrame to CSV
    data = df.to_csv(index=False)
    return Response(
            data,
            mimetype="text/csv",
            headers={"Content-Disposition": "attachment;filename=StudentsPerformance.csv"}
        )

#route to json at 127.0.0.1:5000/jsondata
@app.route('/jsondata', methods=['GET'])
def get_json_data():
    # Load your CSV file
    df = pd.read_csv('dataset/StudentsPerformance.csv')
    # Convert DataFrame to JSON
    data = df.to_dict(orient='records')
    return jsonify(data)

if __name__ == '__main__':
    app.run(debug=True)
    


