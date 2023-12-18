cask "font-xkcd-script" do
  version :latest
  sha256 :no_check

  url "https:github.comipythonxkcd-fontrawmasterxkcd-scriptfontxkcd-script.ttf"
  name "xkcd-script"
  homepage "https:github.comipythonxkcd-font"

  font "xkcd-script.ttf"

  # No zap stanza required
end