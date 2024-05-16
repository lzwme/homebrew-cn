cask "font-blaka" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflblakaBlaka-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Blaka"
  desc "Currently limited to few applications like google chrome (version 98 or later)"
  homepage "https:fonts.google.comspecimenBlaka"

  font "Blaka-Regular.ttf"

  # No zap stanza required
end