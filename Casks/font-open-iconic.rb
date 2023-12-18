cask "font-open-iconic" do
  version "1.1.1"
  sha256 "8acf49f08ae5a069935b48e6be20349c4e9f43fcfc773ea0aba5b972b5b3743c"

  url "https:codeload.github.comiconicopen-iconiczip#{version}",
      verified: "codeload.github.comiconicopen-iconic"
  name "Open Iconic"
  homepage "https:useiconic.comopen"

  font "open-iconic-#{version}fontfontsopen-iconic.ttf"

  # No zap stanza required
end