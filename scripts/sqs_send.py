import boto3
from botocore.exceptions import NoCredentialsError, PartialCredentialsError

# Configura tu región y el nombre de la cola
region_name = 'us-east-1'
queue_name = 'windows_to_inventory_queue_name'

try:
    # Crear cliente de SQS
    sqs = boto3.client('sqs', region_name=region_name)

    # Obtener la URL de la cola
    response = sqs.get_queue_url(QueueName=queue_name)
    queue_url = response['QueueUrl']

    # Enviar un mensaje a la cola
    send_response = sqs.send_message(
        QueueUrl=queue_url,
        MessageBody='Este es un mensaje de prueba'
    )

    print(f'Mensaje enviado con ID: {send_response["MessageId"]}')


except NoCredentialsError:
    print('Credenciales no encontradas.')
except PartialCredentialsError:
    print('Credenciales incompletas.')
except Exception as e:
    print(f'Error: {e}')