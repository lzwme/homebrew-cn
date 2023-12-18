cask "font-hack" do
  version "3.003"
  sha256 "0c2604631b1f055041c68a0e09ae4801acab6c5072ba2db6a822f53c3f8290ac"

  url "https:github.comsource-foundryHackreleasesdownloadv#{version}Hack-v#{version}-ttf.zip",
      verified: "github.comsource-foundryHack"
  name "Hack"
  homepage "https:sourcefoundry.orghack"

  font "ttfHack-Regular.ttf"
  font "ttfHack-Italic.ttf"
  font "ttfHack-Bold.ttf"
  font "ttfHack-BoldItalic.ttf"

  # No zap stanza required
end