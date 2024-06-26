cask "font-awesome-terminal-fonts" do
  version :latest
  sha256 :no_check

  url "https:github.comgabrielelanaawesome-terminal-fontsarchiverefsheadspatching-strategy.tar.gz"
  name "Awesome Terminal Fonts"
  homepage "https:github.comgabrielelanaawesome-terminal-fonts"

  font "awesome-terminal-fonts-patching-strategypatchedDroid+Sans+Mono+Awesome.ttf"
  font "awesome-terminal-fonts-patching-strategypatchedInconsolata+Awesome.ttf"
  font "awesome-terminal-fonts-patching-strategypatchedSourceCodePro+Powerline+Awesome+Regular.ttf"

  # No zap stanza required
end