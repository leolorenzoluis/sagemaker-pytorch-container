python setup.py bdist_wheel
# The name of our algorithm
algorithm_name=spacy-pytorch-transformers

# docker image prune -a -f

$(aws ecr get-login --region us-east-1 --no-include-email)

account=$(aws sts get-caller-identity --query Account --output text)

# Get the region defined in the current configuration (default to us-west-2 if none defined)
region=$(aws configure get region)

fullname="${account}.dkr.ecr.${region}.amazonaws.com/${algorithm_name}"

echo "Build full name: "$fullname

# aws ecr batch-delete-image --repository-name $algorithm_name --image-ids imageTag=latest

# Build docker image
# All build instructions assume you're building from the root directory of the sagemaker-pytorch-container.

# CPU
# docker build -t $fullname:1.0.0-cpu-py3 -f docker/1.2.0/py3/Dockerfile.cpu --build-arg py_version=3 .

# GPU
docker build -t $fullname:1.0.0-gpu-py3 -f docker/1.2.0/py3/Dockerfile.gpu --build-arg py_version=3 .
dockerUrl="${account}.dkr.ecr.${region}.amazonaws.com/${algorithm_name}"
docker push $dockerUrl
echo "Docker image url: "$dockerUrl