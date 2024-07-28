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

    # Recibir mensajes de la cola
    receive_response = sqs.receive_message(
        QueueUrl=queue_url,
        MaxNumberOfMessages=10,  # Puedes ajustar este valor según tus necesidades
        WaitTimeSeconds=10  # Espera hasta 10 segundos por mensajes
    )

    # Procesar los mensajes recibidos
    messages = receive_response.get('Messages', [])
    if not messages:
        print('No se encontraron mensajes.')
    else:
        for message in messages:
            print(f'Mensaje recibido: {message["Body"]}')

            # Eliminar el mensaje de la cola después de procesarlo
            sqs.delete_message(
                QueueUrl=queue_url,
                ReceiptHandle=message['ReceiptHandle']
            )
            print('Mensaje eliminado de la cola.')

except NoCredentialsError:
    print('Credenciales no encontradas.')
except PartialCredentialsError:
    print('Credenciales incompletas.')
except Exception as e:
    print(f'Error inesperado: {e}')