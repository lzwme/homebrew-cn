cask "keyboard-cowboy" do
  version "3.27.2"
  sha256 "d8622b962109d7a14b4a9ca6ea594c4a9f9d7003d6297fbb534661f02aac1d3c"

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