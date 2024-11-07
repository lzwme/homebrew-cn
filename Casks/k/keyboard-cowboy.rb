cask "keyboard-cowboy" do
  version "3.25.3"
  sha256 "662cba4ced22baae2ecd78bd5ac66db21903b0e396d4256500bf8afd0f4c8c7e"

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