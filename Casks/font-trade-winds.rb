cask "font-trade-winds" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofltradewindsTradeWinds-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Trade Winds"
  homepage "https:fonts.google.comspecimenTrade+Winds"

  font "TradeWinds-Regular.ttf"

  # No zap stanza required
end