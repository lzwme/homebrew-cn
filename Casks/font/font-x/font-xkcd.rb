cask "font-xkcd" do
  version :latest
  sha256 :no_check

  url "https:github.comipythonxkcd-fontrawmasterxkcdbuildxkcd.otf"
  name "xkcd"
  homepage "https:github.comipythonxkcd-font"

  font "xkcd.otf"

  # No zap stanza required
end