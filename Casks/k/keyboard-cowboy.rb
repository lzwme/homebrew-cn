cask "keyboard-cowboy" do
  version "3.22.2"
  sha256 "d31982a0e183f651e053c5b2a9f576c00d81165c94a869ff720689a9aad7f0ca"

  url "https:github.comzenangstKeyboardCowboyreleasesdownload#{version}Keyboard.Cowboy.#{version}.dmg"
  name "Keyboard Cowboy"
  desc "Keyboard shortcut utility"
  homepage "https:github.comzenangstKeyboardCowboy"

  auto_updates true
  depends_on macos: ">= :ventura"

  app "Keyboard Cowboy.app"

  zap trash: "~LibraryPreferencescom.zenangst.Keyboard-Cowboy.plist"
end