cask "font-hubballi" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflhubballiHubballi-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Hubballi"
  desc "Monolinear typeface with an informal, friendly appearance"
  homepage "https:fonts.google.comspecimenHubballi"

  font "Hubballi-Regular.ttf"

  # No zap stanza required
end