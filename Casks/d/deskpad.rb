cask "deskpad" do
  version "1.3.2"
  sha256 "b7aae212364193177a6feb2fed6a7942ae9a705d6d491c15e479c58585b85ae0"

  url "https:github.comStengoDeskPadreleasesdownloadv#{version}DeskPad.app.zip"
  name "DeskPad"
  desc "Virtual monitor for screen sharing"
  homepage "https:github.comStengoDeskPad"

  depends_on macos: ">= :ventura"

  app "DeskPad.app"

  zap trash: [
    "~LibraryApplication Scriptscom.stengo.DeskPad",
    "~LibraryContainerscom.stengo.DeskPad",
  ]
end