function yadm_fugitive
  pushd "$HOME"
  GIT_DIR="$(yadm rev-parse --git-dir)" nvim +Git +only
  popd
end
