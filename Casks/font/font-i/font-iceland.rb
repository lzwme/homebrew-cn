cask "font-iceland" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflicelandIceland-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Iceland"
  homepage "https:fonts.google.comspecimenIceland"

  font "Iceland-Regular.ttf"

  # No zap stanza required
end