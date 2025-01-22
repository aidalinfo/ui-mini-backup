docker login rg.fr-par.scw.cloud/open-mini-backup -u nologin -p $SCW_DOCKER
docker build . --file Dockerfile-dev --tag "rg.fr-par.scw.cloud/open-mini-backup/ui-mini-backup:dev"
docker push "rg.fr-par.scw.cloud/open-mini-backup/ui-mini-backup:dev"
# docker tag "rg.fr-par.scw.cloud/open-mini-backup/ui-mini-backup:0.0.1" "rg.fr-par.scw.cloud/open-mini-backup/ui-mini-backup:latest"
# docker push "rg.fr-par.scw.cloud/open-mini-backup/ui-mini-backup:latest"