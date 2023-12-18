cask "deskpad" do
  version "1.3.1"
  sha256 "5b78207c71a2bd4f1bb21e42175e09b9acf25631c23689c7609eb3767e3f0a25"

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