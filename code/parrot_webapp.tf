# Create S3 Bucket for Frontend
resource "aws_s3_bucket" "frontend_bucket" {
  bucket = "parrot-devops-challenge-webapp"

  tags = {
    Name = "ParrotDevOpsChallengeWebApp"
  }
}

# Configure Website for S3 Bucket
resource "aws_s3_bucket_website_configuration" "frontend_bucket_website" {
  bucket = aws_s3_bucket.frontend_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

# Configure Public Access Block for S3 Bucket
resource "aws_s3_bucket_public_access_block" "frontend_bucket_public_access_block" {
  bucket = aws_s3_bucket.frontend_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Configure Ownership Controls for S3 Bucket
resource "aws_s3_bucket_ownership_controls" "frontend_bucket_ownership_controls" {
  bucket = aws_s3_bucket.frontend_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }

  depends_on = [aws_s3_bucket_public_access_block.frontend_bucket_public_access_block]
}

# Configure ACL for S3 Bucket
resource "aws_s3_bucket_acl" "frontend_bucket_acl" {
  bucket = aws_s3_bucket.frontend_bucket.id
  acl    = "public-read"

  depends_on = [aws_s3_bucket_ownership_controls.frontend_bucket_ownership_controls]
}

# Configure Bucket Policy for S3 Bucket to Allow Public Access
resource "aws_s3_bucket_policy" "frontend_bucket_policy" {
  bucket = aws_s3_bucket.frontend_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = "*",
        Action = [
          "s3:GetObject"
        ],
        Resource = [
          "${aws_s3_bucket.frontend_bucket.arn}/*"
        ]
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.frontend_bucket_public_access_block]
}

# Create CloudFront Origin Access Identity
resource "aws_cloudfront_origin_access_identity" "frontend_identity" {
  comment = "Origin access identity for parrot-devops-challenge-webapp bucket"
}

# Create CloudFront Distribution
resource "aws_cloudfront_distribution" "frontend_distribution" {
  origin {
    domain_name = aws_s3_bucket.frontend_bucket.bucket_regional_domain_name
    origin_id   = "S3-parrot-devops-challenge-webapp"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.frontend_identity.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Frontend distribution for parrot-devops-challenge-webapp"
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-parrot-devops-challenge-webapp"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  custom_error_response {
    error_code = 404
    response_code = 200
    response_page_path = "/index.html"
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    Name = "FrontendDistribution"
  }
}
