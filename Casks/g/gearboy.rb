cask "gearboy" do
  arch arm: "arm", intel: "intel"

  version "3.7.0"
  sha256 arm:   "9bb451193e87ff6e8de6efbcb7fe1eeb13e28fb18b4557a8f746a4007f7203e9",
         intel: "bb18837be9f09e3c1b2ff66ab833cf7551d6250f7f582a4ec278d9fa42255534"

  url "https:github.comdrheliusGearboyreleasesdownload#{version}Gearboy-#{version}-macos-#{arch}.zip"
  name "Gearboy"
  desc "Game Boy and Game Boy Color emulator"
  homepage "https:github.comdrheliusGearboy"

  livecheck do
    url :url
    strategy :github_latest
  end

  container nested: "Gearboy.app.zip"

  app "Gearboy.app"

  zap trash: "~LibrarySaved Application Stateme.ignaciosanchez.Gearboy.savedState"
end