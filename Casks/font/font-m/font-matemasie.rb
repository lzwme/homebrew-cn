cask "font-matemasie" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmatemasieMatemasie-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Matemasie"
  homepage "https:fonts.google.comspecimenMatemasie"

  font "Matemasie-Regular.ttf"

  # No zap stanza required
end