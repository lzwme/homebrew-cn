cask "font-ravi-prakash" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflraviprakashRaviPrakash-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Ravi Prakash"
  homepage "https:fonts.google.comspecimenRavi+Prakash"

  font "RaviPrakash-Regular.ttf"

  # No zap stanza required
end