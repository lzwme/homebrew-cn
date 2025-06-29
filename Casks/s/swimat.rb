cask "swimat" do
  version "1.7.0"
  sha256 "adcf450d98c247fe4c45c68353f19afca3e2039c8431ec080f14000fe9cc36bf"

  url "https:github.comJintinSwimatreleasesdownload#{version}Swimat.zip"
  name "Swimat"
  desc "Xcode formatter plug-in for Swift code"
  homepage "https:github.comJintinSwimat"

  no_autobump! because: :requires_manual_review

  app "Swimat.app"

  zap trash: [
    "usrlocalbinswimat",
    "~LibraryContainerscom.jintin.Swimat.Extension",
    "~LibraryGroup Containerscom.jintin.swimat.configuration",
  ]
end