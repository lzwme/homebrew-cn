cask "font-unlock" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflunlockUnlock-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Unlock"
  homepage "https:fonts.google.comspecimenUnlock"

  font "Unlock-Regular.ttf"

  # No zap stanza required
end