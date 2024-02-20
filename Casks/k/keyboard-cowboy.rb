cask "keyboard-cowboy" do
  version "3.22.1"
  sha256 "20f7cbef7ddd54267d749816e6271b42f4cc01352da1e6802f60738f929ad42b"

  url "https:github.comzenangstKeyboardCowboyreleasesdownload#{version}Keyboard.Cowboy.#{version}.dmg"
  name "Keyboard Cowboy"
  desc "Keyboard shortcut utility"
  homepage "https:github.comzenangstKeyboardCowboy"

  auto_updates true
  depends_on macos: ">= :ventura"

  app "Keyboard Cowboy.app"

  zap trash: "~LibraryPreferencescom.zenangst.Keyboard-Cowboy.plist"
end