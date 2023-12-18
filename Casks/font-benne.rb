cask "font-benne" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflbenneBenne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Benne"
  desc "Kannada text font developed by john harrington"
  homepage "https:fonts.google.comspecimenBenne"

  font "Benne-Regular.ttf"

  # No zap stanza required
end