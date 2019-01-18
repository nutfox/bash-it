cite about-plugin
about-plugin 'Helpers to more easily work with Docker'

function docker-remove-most-recent-container() {
  about 'attempt to remove the most recent container from docker ps -a'
  group 'docker'
  docker ps -ql | xargs docker rm
}

function docker-remove-most-recent-image() {
  about 'attempt to remove the most recent image from docker images'
  group 'docker'
  docker images -q | head -1 | xargs docker rmi
}

function docker-remove-stale-assets() {
  about 'attempt to remove exited containers and dangling images'
  group 'docker'
  docker ps --filter status=exited -q | xargs docker rm --volumes
  docker images --filter dangling=true -q | xargs docker rmi
}

function docker-enter() {
  about 'enter the specified docker container using bash'
  group 'docker'
  param '1: Name of the container to enter'
  example 'docker-enter oracle-xe'

  # Some versions of Docker don't like the ALL_PROXY variable
  # An error like "proxy: unknown scheme: http" might be seen
  unset ALL_PROXY
  docker exec -it "$@" /bin/bash;
}

function docker-remove-images() {
  about 'attempt to remove images with supplied tags or all if no tags are supplied'
  group 'docker'
  if [ -z "$1" ]; then
    docker rmi $(docker images -q)
  else
    DOCKER_IMAGES=""
    for IMAGE_ID in $@; do DOCKER_IMAGES="$DOCKER_IMAGES\|$IMAGE_ID"; done
    # Find the image IDs for the supplied tags
    ID_ARRAY=($(docker images | grep "${DOCKER_IMAGES:2}" | awk {'print $1":"$2'}))
    # Strip out duplicate IDs before attempting to remove the image(s)
    docker rmi $(echo ${ID_ARRAY[@]} | tr ' ' '\n' | sort -u | tr '\n' ' ')
 fi
}

function docker-remove-images-fuzzy() {
  about 'attempt to remove images with fuzzy selection, requires fzf: https://github.com/junegunn/fzf'
  group 'docker'
  example 'docker-remove-images-fuzzy latest'
  param '1: query parameter for fzf (optional)'

  # Filter out the first (header) line of `docker images`.
  # Run fzf in multi-select mode (TAB)
  # Identify selected items through "repo:tag"
  ID_ARRAY=($(docker images | sed '1d' | fzf --query="$1" -m | awk {'print $1":"$2'}))

  # Don't do anything if nothing was selected.
  if [ ${#ID_ARRAY[@]} -gt 0 ]; then
    # Strip out duplicate IDs before attempting to remove the image(s)
    docker rmi $(echo ${ID_ARRAY[@]} | tr ' ' '\n' | sort -u | tr '\n' ' ')
  fi
}

function docker-image-dependencies() {
  about 'attempt to create a Graphiz image of the supplied image ID dependencies'
  group 'docker'
  if hash dot 2>/dev/null; then
    OUT=$(mktemp -t docker-viz-XXXX.png)
    docker images -viz | dot -Tpng > $OUT
    case $OSTYPE in
      linux*)
        xdg-open $OUT
        ;;
      darwin*)
        open $OUT
        ;;
    esac
  else
    >&2 echo "Can't show dependencies; Graphiz is not installed"
  fi
}

function docker-runtime-environment() {
  about 'attempt to list the environmental variables of the supplied image ID'
  group 'docker'
  docker run "$@" env
}

function docker-archive-content() {
  about 'show the content of the provided Docker image archive'
  group 'docker'
  param '1: image archive name'
  example 'docker-archive-content images.tar.gz'

  if [ -n "$1" ]; then
    tar -xzOf $1 manifest.json | jq '[.[] | .RepoTags] | add'
  fi
}
