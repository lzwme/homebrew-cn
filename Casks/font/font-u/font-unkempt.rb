cask "font-unkempt" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "apacheunkempt"
  name "Unkempt"
  homepage "https:fonts.google.comspecimenUnkempt"

  font "Unkempt-Bold.ttf"
  font "Unkempt-Regular.ttf"

  # No zap stanza required
end