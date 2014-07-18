from flask import Flask,request
import time

app = Flask(__name__)

@app.route('/hello')
def hello():
    return 'Hello World'


@app.route('/tem_log', methods=['POST'])
def add_to_file():
    error = None
    f = open('temperature_log', 'a')
    f.write(request.form['temperature'])
    f.close()
    #handle_temperature(request.form['temperature'])
    return 'OK'

def handle_temperature(temperature):

    f = open('temperature_log', 'a')
    f.write(temperature)
    f.write(time.time())
    f.write('\n')
    print temperature
    

    #f.write('dd')
    f.close()

   


if __name__ == '__main__':
    app.debug= True
    app.run(host='0.0.0.0')
    



