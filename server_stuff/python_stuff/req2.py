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
    a=str(time.time())
    f.write(a)
    f.write(' ')
    f.write(request.form['temperature'])
    f.write(' ')
    f.write(request.form['humidity'])
    f.write('\n')
    f.close()
    
    return 'OK'

def handle_temperature_(temperature):

    f = open('temperature_log', 'a') 
    a=str(time.time())
    f.write(a)
    f.write(' ')
    f.write(temperature)
    f.write('\n')
    #a=time.time()
    #f.write(str(a))
    #f.write('   ')    
    f.close()

if __name__ == '__main__':
    app.debug= True
    app.run(host='0.0.0.0')
    



