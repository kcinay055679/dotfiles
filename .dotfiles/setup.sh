cd ~
GIT_NAME=$(git config user.name)
GIT_EMAIL=$(git config user.email)
REPO_NAME="dotfiles"
FOLDER_NAME=".dotfiles"

echo ".cfg" >> .gitignore
git clone --bare git@github.com:kcinay055679/$REPO_NAME.git $HOME/$FOLDER_NAME

dotfiles(){
   /usr/bin/git --git-dir=$HOME/$FOLDER_NAME/ --work-tree=$HOME $@
}


dotfilesCo(){
  dotfiles checkout -- $(dotfiles diff --name-only | grep -E -v "README.md|setup.sh")
}

mkdir -p $FOLDER_NAME
dotfilesCo
if [ $? = 0 ]; then
  echo "Checked out config.";
  else
    echo "Backing up pre-existing dot files.";
    dotfilesCo 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} ($FOLDER_NAME)-backup/{}
fi;
dotfilesCo
config config status.showUntrackedFiles no
git config --global user.name $GIT_NAME
git config --global user.email $GIT_EMAIL
