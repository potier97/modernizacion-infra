from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.exc import SQLAlchemyError
import boto3
from botocore.exceptions import NoCredentialsError, PartialCredentialsError
import threading
import json

app = Flask(__name__)

# Configuración de la base de datos
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://user:pwd@localhos:5432/db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

class Inventario(db.Model):
    __tablename__ = 'productos'
    id = db.Column(db.Integer, primary_key=True)
    codigo = db.Column(db.String, nullable=False)
    nombre = db.Column(db.String, nullable=False)
    proveedor = db.Column(db.Integer, nullable=False)
    stock = db.Column(db.Integer, nullable=False)
    precio = db.Column(db.Float, nullable=False)

def process_message(data):
    with app.app_context():
        try:
            nuevo_producto = Inventario(
                codigo=data['codigo'],
                nombre=data['nombre'],
                proveedor=data['proveedor'],
                stock=data['stock'],
                precio=data['precio']
            )
            db.session.add(nuevo_producto)
            db.session.commit()
            print('Mensaje guardado en la base de datos.')
        except (KeyError, SQLAlchemyError) as e:
            print(f'Error al procesar el mensaje: {e}')
            db.session.rollback()

def listen_to_sqs():
    region_name = 'us-east-1'
    queue_name = 'queue-name'

    try:
        sqs = boto3.client('sqs', region_name=region_name)
        response = sqs.get_queue_url(QueueName=queue_name)
        queue_url = response['QueueUrl']

        while True:
            receive_response = sqs.receive_message(
                QueueUrl=queue_url,
                MaxNumberOfMessages=10,
                WaitTimeSeconds=10
            )

            messages = receive_response.get('Messages', [])
            if messages:
                for message in messages:
                    print(f'Mensaje recibido: {message["Body"]}')
                    try:
                        data = json.loads(message["Body"])
                        process_message(data)
                        sqs.delete_message(
                            QueueUrl=queue_url,
                            ReceiptHandle=message['ReceiptHandle']
                        )
                        print('Mensaje eliminado de la cola.')
                    except json.JSONDecodeError as e:
                        print(f'Error al decodificar el mensaje JSON: {e}')
    except NoCredentialsError:
        print('Credenciales no encontradas.')
    except PartialCredentialsError:
        print('Credenciales incompletas.')
    except Exception as e:
        print(f'Error inesperado: {e}')

if __name__ == '__main__':
    with app.app_context():
        db.create_all()
    threading.Thread(target=listen_to_sqs).start()
    app.run(host='0.0.0.0', port=5000)