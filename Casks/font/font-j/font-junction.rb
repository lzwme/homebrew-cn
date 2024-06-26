cask "font-junction" do
  version :latest
  sha256 :no_check

  url "https:github.comtheleagueofjunctionarchiverefsheadsmaster.tar.gz",
      verified: "github.comtheleagueofjunction"
  name "Junction"
  homepage "https:www.theleagueofmoveabletype.comjunction"

  font "junction-masterJunction-bold.otf"
  font "junction-masterJunction-light.otf"
  font "junction-masterJunction-regular.otf"

  # No zap stanza required
end