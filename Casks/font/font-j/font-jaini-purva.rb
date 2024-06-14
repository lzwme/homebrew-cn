cask "font-jaini-purva" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofljainipurvaJainiPurva-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Jaini Purva"
  homepage "https:fonts.google.comspecimenJaini+Purva"

  font "JainiPurva-Regular.ttf"

  # No zap stanza required
end