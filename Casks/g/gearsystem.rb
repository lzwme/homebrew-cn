cask "gearsystem" do
  arch arm: "arm", intel: "intel"

  version "3.6.1"
  sha256 arm:   "fa58f9f61da2588e88de53c1fc9c9c5fd06bc301200b32edaf56000be5f8ced1",
         intel: "dc34b0715c6141f93c146b48a7f884a4b86ccaa58a3d6d16bc08ae161518e4a3"

  url "https:github.comdrheliusGearsystemreleasesdownload#{version}Gearsystem-#{version}-macos-#{arch}.zip"
  name "Gearsystem"
  desc "Sega Master System, Game Gear and SG-1000 emulator"
  homepage "https:github.comdrheliusGearsystem"

  container nested: "Gearsystem.app.zip"

  app "Gearsystem.app"

  zap trash: "~LibrarySaved Application Stateme.ignaciosanchez.Gearsystem.savedState"
end