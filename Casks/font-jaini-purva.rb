cask "font-jaini-purva" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofljainipurvaJainiPurva-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Jaini Purva"
  desc "Typeface based on the calligraphic style of the Jain Kalpasutra manuscripts"
  homepage "https:fonts.google.comspecimenJaini+Purva"

  font "JainiPurva-Regular.ttf"

  # No zap stanza required
end