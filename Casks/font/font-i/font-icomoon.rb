cask "font-icomoon" do
  version :latest
  sha256 :no_check

  url "https:github.comKeyamoonIcoMoon-Freearchiverefsheadsmaster.tar.gz",
      verified: "github.comKeyamoonIcoMoon-Free"
  name "IcoMoon"
  homepage "https:icomoon.io"

  font "IcoMoon-Free-masterFontIcoMoon-Free.ttf"

  # No zap stanza required
end