cask "font-namdhinggo" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      branch:    "main",
      only_path: "oflnamdhinggo"
  name "Namdhinggo"
  homepage "https:github.comsilnrsifont-namdhinggo"

  font "Namdhinggo-Bold.ttf"
  font "Namdhinggo-ExtraBold.ttf"
  font "Namdhinggo-Medium.ttf"
  font "Namdhinggo-Regular.ttf"
  font "Namdhinggo-SemiBold.ttf"

  # No zap stanza required
end