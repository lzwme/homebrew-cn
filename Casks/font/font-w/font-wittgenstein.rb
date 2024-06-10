cask "font-wittgenstein" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      branch:    "main",
      only_path: "oflwittgenstein"
  name "Wittgenstein"
  homepage "https:github.comjrgdrsWittgenstein"

  font "Wittgenstein-Italic[wght].ttf"
  font "Wittgenstein[wght].ttf"

  # No zap stanza required
end