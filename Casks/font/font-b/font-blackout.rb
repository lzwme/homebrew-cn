cask "font-blackout" do
  version :latest
  sha256 :no_check

  url "https:github.comtheleagueofblackoutarchiverefsheadsmaster.tar.gz",
      verified: "github.comtheleagueofblackout"
  name "Blackout"
  homepage "https:www.theleagueofmoveabletype.comblackout"

  font "blackout-masterBlackout 2 AM.ttf"
  font "blackout-masterBlackout Midnight.ttf"
  font "blackout-masterBlackout Sunrise.ttf"

  # No zap stanza required
end