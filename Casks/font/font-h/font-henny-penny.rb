cask "font-henny-penny" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflhennypennyHennyPenny-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Henny Penny"
  homepage "https:fonts.google.comspecimenHenny+Penny"

  font "HennyPenny-Regular.ttf"

  # No zap stanza required
end