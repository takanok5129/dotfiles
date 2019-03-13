files=(
  ".bash_profile"
  ".config"
  ".vimrc"
  ".zsh"
)

curd=`dirname $0`
cd $HOME

for file in ${files[@]}; do
  echo "${curd}/${file} -> ${HOME}/${file}"
  ln -s "${curd}/${file}"
done
