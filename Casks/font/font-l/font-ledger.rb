cask "font-ledger" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflledgerLedger-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Ledger"
  homepage "https:fonts.google.comspecimenLedger"

  font "Ledger-Regular.ttf"

  # No zap stanza required
end