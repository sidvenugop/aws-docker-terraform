docker login tutum        #Expecting public repoo
docker pull tutum/hello-world

IMAGE_ID = docker images | awk '{print $3}' | awk 'FNR ==2'  #Get image ID from image list

docker run -it $IMAGE_ID -p 8080:8080

