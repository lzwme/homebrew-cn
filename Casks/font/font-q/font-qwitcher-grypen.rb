cask "font-qwitcher-grypen" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflqwitchergrypen"
  name "Qwitcher Grypen"
  desc "Casual brush script with a bit of an edge"
  homepage "https:fonts.google.comspecimenQwitcher+Grypen"

  font "QwitcherGrypen-Bold.ttf"
  font "QwitcherGrypen-Regular.ttf"

  # No zap stanza required
end