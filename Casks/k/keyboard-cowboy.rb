cask "keyboard-cowboy" do
  version "3.20.2"
  sha256 "90a9a09ce0c197e8489506dfc542c294013b5596befcf9cfca54ec8e909ccefe"

  url "https:github.comzenangstKeyboardCowboyreleasesdownload#{version}Keyboard.Cowboy.#{version}.dmg"
  name "Keyboard Cowboy"
  desc "Keyboard shortcut utility"
  homepage "https:github.comzenangstKeyboardCowboy"

  auto_updates true
  depends_on macos: ">= :ventura"

  app "Keyboard Cowboy.app"

  zap trash: "~LibraryPreferencescom.zenangst.Keyboard-Cowboy.plist"
end