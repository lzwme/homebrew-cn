cask "font-kay-pho-du" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflkayphodu"
  name "Kay Pho Du"
  desc "Font family for the kayah li script"
  homepage "https:fonts.google.comspecimenKay+Pho+Du"

  font "KayPhoDu-Bold.ttf"
  font "KayPhoDu-Medium.ttf"
  font "KayPhoDu-Regular.ttf"
  font "KayPhoDu-SemiBold.ttf"

  # No zap stanza required
end