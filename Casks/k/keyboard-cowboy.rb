cask "keyboard-cowboy" do
  version "3.24.2"
  sha256 "3086c2c7c99c49a9947abd91e3aecc7bfedbba0c5cc2042bb50ba328b0bba893"

  url "https:github.comzenangstKeyboardCowboyreleasesdownload#{version}Keyboard.Cowboy.#{version}.dmg"
  name "Keyboard Cowboy"
  desc "Keyboard shortcut utility"
  homepage "https:github.comzenangstKeyboardCowboy"

  auto_updates true
  depends_on macos: ">= :ventura"

  app "Keyboard Cowboy.app"

  zap trash: [
    "~.keyboard-cowboy.json",
    "~LibraryHTTPStoragescom.zenangst.Keyboard-Cowboy",
    "~LibraryPreferencescom.zenangst.Keyboard-Cowboy.plist",
  ]
end