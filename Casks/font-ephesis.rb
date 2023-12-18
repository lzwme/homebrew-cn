cask "font-ephesis" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflephesisEphesis-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Ephesis"
  desc "Contemporary script great for casual invitations, cards, tubes, scrapbooking"
  homepage "https:fonts.google.comspecimenEphesis"

  font "Ephesis-Regular.ttf"

  # No zap stanza required
end