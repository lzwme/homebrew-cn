cask "font-content" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflcontent"
  name "Content"
  homepage "https:fonts.google.comspecimenContent"

  font "Content-Bold.ttf"
  font "Content-Regular.ttf"

  # No zap stanza required
end