cask "font-qahiri" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflqahiriQahiri-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Qahiri"
  homepage "https:fonts.google.comspecimenQahiri"

  font "Qahiri-Regular.ttf"

  # No zap stanza required
end