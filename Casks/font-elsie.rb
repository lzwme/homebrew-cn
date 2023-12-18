cask "font-elsie" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflelsie"
  name "Elsie"
  homepage "https:fonts.google.comspecimenElsie"

  font "Elsie-Black.ttf"
  font "Elsie-Regular.ttf"

  # No zap stanza required
end