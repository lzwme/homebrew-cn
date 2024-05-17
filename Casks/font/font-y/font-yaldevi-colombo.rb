cask "font-yaldevi-colombo" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflyaldevicolombo"
  name "Yaldevi Colombo"
  homepage "https:fonts.google.comspecimenYaldevi"

  font "YaldeviColombo-Bold.ttf"
  font "YaldeviColombo-ExtraLight.ttf"
  font "YaldeviColombo-Light.ttf"
  font "YaldeviColombo-Medium.ttf"
  font "YaldeviColombo-Regular.ttf"
  font "YaldeviColombo-SemiBold.ttf"

  # No zap stanza required
end