cask "font-b612" do
  version "1.008"
  sha256 "727cb91e47d65ac49c2d97d7b1c36d9891b885d9ddf06e15ad3d23d22bdad9cf"

  url "https:github.compolarsysb612archiverefstags#{version}.zip",
      verified: "github.compolarsysb612"
  name "B612"
  desc "Font designed and tested to be used on aircraft cockpit screens"
  homepage "https:b612-font.com"

  font "b612-#{version}fontsttfB612-Bold.ttf"
  font "b612-#{version}fontsttfB612-BoldItalic.ttf"
  font "b612-#{version}fontsttfB612-Italic.ttf"
  font "b612-#{version}fontsttfB612-Regular.ttf"

  # No zap stanza required
end