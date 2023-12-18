cask "font-hind-jalandhar" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      branch:    "main",
      only_path: "oflhindjalandhar"
  name "Hind Jalandhar"
  homepage "https:github.comitfoundryhind-jalandhar"

  font "HindJalandhar-Bold.ttf"
  font "HindJalandhar-Light.ttf"
  font "HindJalandhar-Medium.ttf"
  font "HindJalandhar-Regular.ttf"
  font "HindJalandhar-SemiBold.ttf"

  # No zap stanza required
end