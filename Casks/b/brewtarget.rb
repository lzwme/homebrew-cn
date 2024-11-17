cask "brewtarget" do
  version "4.0.10"
  sha256 "87ec74b26bce1070711bc1efcc9fe1addee2f947a9baa28d7795abcd1b335ebe"

  url "https:github.comBrewtargetbrewtargetreleasesdownloadv#{version}brewtarget_#{version}.dmg"
  name "brewtarget"
  desc "Beer recipe creation tool"
  homepage "https:github.comBrewtargetbrewtarget"

  app "brewtarget_#{version}.app"

  zap trash: [
    "~LibraryPreferencesbrewtarget",
    "~LibraryPreferencescom.brewtarget.Brewtarget.plist",
    "~LibrarySaved Application Statecom.brewtarget.Brewtarget.savedState",
  ]
end