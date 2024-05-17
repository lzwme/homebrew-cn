cask "font-medula-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmedulaoneMedulaOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Medula One"
  homepage "https:fonts.google.comspecimenMedula+One"

  font "MedulaOne-Regular.ttf"

  # No zap stanza required
end