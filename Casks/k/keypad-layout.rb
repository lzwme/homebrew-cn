cask "keypad-layout" do
  version "1.11"
  sha256 "0d4b75ee6077eed9b5eab03f14699d8a1d635d54ee6cbbdb5d5083c1cdd08d23"

  url "https:github.comjantenkeypad-layoutreleasesdownload#{version}Keypad-Layout.zip"
  name "Keypad Layout"
  desc "Utility to control window layout using the Ctrl key and the numeric keypad"
  homepage "https:github.comjantenkeypad-layout"

  app "Keypad Layout.app"

  zap trash: "~LibraryPreferencescom.jan-gerd.keypad-layout.plist"
end