cask "font-hind-madurai" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflhindmadurai"
  name "Hind Madurai"
  homepage "https:fonts.google.comspecimenHind+Madurai"

  font "HindMadurai-Bold.ttf"
  font "HindMadurai-Light.ttf"
  font "HindMadurai-Medium.ttf"
  font "HindMadurai-Regular.ttf"
  font "HindMadurai-SemiBold.ttf"

  # No zap stanza required
end