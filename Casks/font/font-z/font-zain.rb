cask "font-zain" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      branch:    "main",
      only_path: "oflzain"
  name "Zain"
  homepage "https:github.comgooglefontszain"

  font "Zain-Black.ttf"
  font "Zain-Bold.ttf"
  font "Zain-ExtraBold.ttf"
  font "Zain-ExtraLight.ttf"
  font "Zain-Light.ttf"
  font "Zain-Regular.ttf"

  # No zap stanza required
end