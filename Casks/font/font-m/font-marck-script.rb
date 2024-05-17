cask "font-marck-script" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmarckscriptMarckScript-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Marck Script"
  homepage "https:fonts.google.comspecimenMarck+Script"

  font "MarckScript-Regular.ttf"

  # No zap stanza required
end