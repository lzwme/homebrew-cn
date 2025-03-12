cask "keyboard-cowboy" do
  version "3.27.0"
  sha256 "9c01a6391637963754be59ceaf98ee6f4972ea1526bfdaed8e2baee090643bd5"

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