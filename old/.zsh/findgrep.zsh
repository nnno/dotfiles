# ackコマンドがあればそれを実行、無いならfind + grepの組み合わせで実行する
findgrep () {
  local ack
  case "${OSTYPE}" in
    darwin*)
      ack="ack";
      ;;
    linux*)
      ack="ack-grep";
      ;;
  esac

  if which pt > /dev/null; then
    pt $@
  elif which $ack &> /dev/null; then
    eval $ack $@
  else 
    find . -type f -print | xargs grep -in --binary-files=without-match $@
  fi
}
