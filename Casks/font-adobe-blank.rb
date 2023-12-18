cask "font-adobe-blank" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofladobeblankAdobeBlank-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Adobe Blank"
  homepage "https:fonts.google.comspecimenAdobe+Blank"

  font "AdobeBlank-Regular.ttf"

  # No zap stanza required
end