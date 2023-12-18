cask "font-bentham" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflbenthamBentham-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Bentham"
  homepage "https:fonts.google.comspecimenBentham"

  font "Bentham-Regular.ttf"

  # No zap stanza required
end