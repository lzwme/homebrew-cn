cask "font-atomic-age" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflatomicageAtomicAge-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Atomic Age"
  homepage "https:fonts.google.comspecimenAtomic+Age"

  font "AtomicAge-Regular.ttf"

  # No zap stanza required
end