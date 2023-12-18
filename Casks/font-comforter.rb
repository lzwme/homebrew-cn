cask "font-comforter" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflcomforterComforter-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Comforter"
  desc "Appealing for many usages"
  homepage "https:fonts.google.comspecimenComforter"

  font "Comforter-Regular.ttf"

  # No zap stanza required
end