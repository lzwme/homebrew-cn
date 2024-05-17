cask "font-mouse-memoirs" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmousememoirsMouseMemoirs-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Mouse Memoirs"
  homepage "https:fonts.google.comspecimenMouse+Memoirs"

  font "MouseMemoirs-Regular.ttf"

  # No zap stanza required
end