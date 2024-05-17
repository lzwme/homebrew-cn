cask "font-yesteryear" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflyesteryearYesteryear-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Yesteryear"
  homepage "https:fonts.google.comspecimenYesteryear"

  font "Yesteryear-Regular.ttf"

  # No zap stanza required
end