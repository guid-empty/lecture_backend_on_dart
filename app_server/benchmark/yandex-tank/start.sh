docker run \
  --network host \
  --entrypoint /bin/bash   \
  -v $(pwd):/var/loadtest   \
  -v $HOME/.ssh:/root/.ssh \
  -it direvius/yandex-tank  \
