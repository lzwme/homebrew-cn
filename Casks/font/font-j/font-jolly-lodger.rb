cask "font-jolly-lodger" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofljollylodgerJollyLodger-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Jolly Lodger"
  homepage "https:fonts.google.comspecimenJolly+Lodger"

  font "JollyLodger-Regular.ttf"

  # No zap stanza required
end