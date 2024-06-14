cask "font-qwitcher-grypen" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflqwitchergrypen"
  name "Qwitcher Grypen"
  homepage "https:fonts.google.comspecimenQwitcher+Grypen"

  font "QwitcherGrypen-Bold.ttf"
  font "QwitcherGrypen-Regular.ttf"

  # No zap stanza required
end