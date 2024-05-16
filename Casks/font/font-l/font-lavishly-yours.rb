cask "font-lavishly-yours" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofllavishlyyoursLavishlyYours-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Lavishly Yours"
  desc "Charming calligraphic script"
  homepage "https:fonts.google.comspecimenLavishly+Yours"

  font "LavishlyYours-Regular.ttf"

  # No zap stanza required
end