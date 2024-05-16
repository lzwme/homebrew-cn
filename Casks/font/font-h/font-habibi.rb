cask "font-habibi" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflhabibiHabibi-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Habibi"
  homepage "https:fonts.google.comspecimenHabibi"

  font "Habibi-Regular.ttf"

  # No zap stanza required
end