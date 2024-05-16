cask "font-dhyana" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "ofldhyana"
  name "Dhyana"
  homepage "https:fonts.google.comearlyaccess"

  font "Dhyana-Bold.ttf"
  font "Dhyana-Regular.ttf"

  # No zap stanza required
end