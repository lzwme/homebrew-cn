cask "font-inspiration" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflinspirationInspiration-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Inspiration"
  homepage "https:fonts.google.comspecimenInspiration"

  font "Inspiration-Regular.ttf"

  # No zap stanza required
end