

deploy token:
ops-admin

gldt-C2s_aqcacsry1F_8xvQ9

## LOGIN to docker 

docker logout registry.gitlab.com
echo "<YOUR_TOKEN>" | docker login registry.gitlab.com \
  --username <YOUR_USERNAME> \
  --password-stdin


## BUild docker images and push to registry

docker build . -t registry.gitlab.com/holocron-lab/project-deathstar:latest


docker push registry.gitlab.com/holocron-lab/project-deathstar:latest



## Deploy the app

1.  Apply the secret

kubectl create secret docker-registry gitlab-registry --namespace=exegol \
  --docker-server=registry.gitlab.com \
  --docker-username=ops-admin \
  --docker-password=gldt-C2s_aqcacsry1F_8xvQ9 \
  --docker-email=mustafar.ops@gmail.com
  

2. add the reference to values.yaml

image:
  repository: registry.gitlab.com/holocron-lab/project-deathstar
  pullPolicy: IfNotPresent
  tag: "latest"

imagePullSecrets:
  - name: gitlab-registry


3. update deployment with image pull secret

spec:
  template:
    spec:
      imagePullSecrets:
        {{- toYaml .Values.imagePullSecrets | indent 8 }}
      containers:
        - name: crewai
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
          …
