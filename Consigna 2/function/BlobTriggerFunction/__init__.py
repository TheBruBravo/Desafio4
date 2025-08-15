import logging
import os
from azure.storage.blob import BlobServiceClient
import azure.functions as func

def main(myblob: func.InputStream):
    name = myblob.name.split('/')[-1]
    dest_connection = os.getenv("DESTINATION_CONNECTION")
    dest_container = os.getenv("DESTINATION_CONTAINER")

    dest_client = BlobServiceClient.from_connection_string(dest_connection)
    dest_blob = dest_client.get_blob_client(container=dest_container, blob=name)

    dest_blob.upload_blob(myblob.read(), overwrite=True)
    logging.info(f"Archivo {name} copiado correctamente.")
