# dotfiles
dotfiles.

## Prerequisites
- Using chezmoi. Please install it in advance.
- If you're using macOS, hit the following command.

```
brew install chezmoi
```

## Spinning up my environment

First `chezmoi init`.

```
chezmoi init git@github.com:noir-h/dotfiles.git
```

Apply my settings.

```
chezmoi apply
```

対象のディレクトリ・ファイルだけapplyする場合はpathを指定する

```
chezmoi apply .config/nvim
```

.dotfileを修正するとき
例: chezmoi edit .gitconfig
```
chezmoi edit .dotfile
```
上記は本リポジトリのdot_fileを修正する、localの環境にも反映させる場合はapplyを実行する
```
chezmoi apply
```

test
