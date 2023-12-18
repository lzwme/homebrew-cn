cask "font-jomhuria" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofljomhuriaJomhuria-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Jomhuria"
  homepage "https:fonts.google.comspecimenJomhuria"

  font "Jomhuria-Regular.ttf"

  # No zap stanza required
end