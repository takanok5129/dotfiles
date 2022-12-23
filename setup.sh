files=(
  ".atom"
  ".bash_profile"
  ".config"
  ".golangci.yml"
  ".my.cnf"
  ".vimrc"
  ".zsh"
  ".zshrc"
)

curd=`dirname $0`
cd $HOME

for file in ${files[@]}; do
  echo "${curd}/${file} -> ${HOME}/${file}"
  ln -s "${curd}/${file}"
done
