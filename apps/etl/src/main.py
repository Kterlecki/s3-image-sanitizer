
import json
import boto3
import logging
from typing import Dict, Any
from io import BytesIO
from PIL import Image
import os

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Initialize S3 client - outside of the handler to reuse the client across invocations + lower latency
s3_client = boto3.client('s3')

def lambda_handler(event: Dict[str, Any], context: Any) -> Dict[str, Any]:
    """
    Lambda entry point for S3 event processing.
    Processes S3 ObjectCreated events to sanitize JPG images.
    """
    try:
        # Parse S3 event
        for record in event.get('Records', []):
            if record.get('eventSource') == 'aws:s3':
                bucket_name = record['s3']['bucket']['name']
                object_key = record['s3']['object']['key']
                
                logger.info(f"Processing file: {object_key} from bucket: {bucket_name}")
                
                # Process only JPG files
                if not object_key.lower().endswith(('.jpg')):
                    logger.info(f"Skipping non-JPG file: {object_key}")
                else:
                   process_image(bucket_name, object_key)

        return {
            'statusCode': 200,
            'body': json.dumps('Images processed successfully')
        }
        
    except Exception as e:
        logger.error(f"Error processing event: {str(e)}")
        raise

def process_image(source_bucket: str, object_key: str) -> None:
    """
    Download image from source bucket, remove EXIF data, and upload to destination bucket.
    
    Args:
        source_bucket: Name of the source S3 bucket
        object_key: S3 object key (file path)
    """
    # Get destination bucket from environment variable
    destination_bucket = os.environ.get('DESTINATION_BUCKET')
    if not destination_bucket:
        raise ValueError("DESTINATION_BUCKET environment variable not set")
    
    destination_key = f"images/{object_key}"
    
    try:
        # Download image from source bucket
        logger.info(f"Downloading {object_key} from {source_bucket}")
        response = s3_client.get_object(Bucket=source_bucket, Key=object_key)
        image_data = response['Body'].read()
        
        # Process image to remove EXIF data
        logger.info(f"Removing EXIF data from {object_key}")
        sanitized_image_data = remove_exif_metadata(image_data)
        
        destination_key = f"images/{object_key}"
        logger.info(f"Uploading sanitized image to {destination_bucket}/{destination_key}")
        s3_client.put_object(
            Bucket=destination_bucket,
            Key=destination_key,
            Body=sanitized_image_data,
            ContentType='image/jpeg'
        )
        
        logger.info(f"Successfully processed and uploaded {object_key}")
        
    except Exception as e:
        logger.error(f"Error processing image {object_key}: {str(e)}")
        raise

def remove_exif_metadata(image_data: bytes) -> bytes:
    """
    Remove EXIF metadata from JPG image data.
    
    Args:
        image_data: Raw image bytes
        
    Returns:
        Image bytes without EXIF metadata
    """
    try:
        # Open image with PIL
        image = Image.open(BytesIO(image_data))
        
        # Create a new image without EXIF data
        # Convert to RGB if needed (handles RGBA, P mode, etc.)
        if image.mode != 'RGB':
            image = image.convert('RGB')
        
        # Save image without EXIF data
        output_buffer = BytesIO()
        image.save(output_buffer, format='JPG', quality=95, optimize=True)
        
        # Get the sanitized image data
        sanitized_data = output_buffer.getvalue()
        output_buffer.close()
        
        return sanitized_data
        
    except Exception as e:
        logger.error(f"Error removing EXIF metadata: {str(e)}")
        raise
