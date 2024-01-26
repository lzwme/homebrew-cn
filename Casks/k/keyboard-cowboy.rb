cask "keyboard-cowboy" do
  version "3.21.0"
  sha256 "e9ea936fa93d409d9153192ee8f8c6e7cf47c2dc7f8b198205ad0bb9dcbdbe3b"

  url "https:github.comzenangstKeyboardCowboyreleasesdownload#{version}Keyboard.Cowboy.#{version}.dmg"
  name "Keyboard Cowboy"
  desc "Keyboard shortcut utility"
  homepage "https:github.comzenangstKeyboardCowboy"

  auto_updates true
  depends_on macos: ">= :ventura"

  app "Keyboard Cowboy.app"

  zap trash: "~LibraryPreferencescom.zenangst.Keyboard-Cowboy.plist"
end