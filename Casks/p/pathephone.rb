cask "pathephone" do
  version "2.2.1"
  sha256 "94f11a3dfd047aff65fa15430a127e07d733518dd39618a15344fc4738a74806"

  url "https:github.compathephonepathephone-desktopreleasesdownloadv#{version}Pathephone-#{version}.dmg",
      verified: "github.compathephonepathephone-desktop"
  name "Pathephone"
  desc "Distributed audio player"
  homepage "https:pathephone.github.io"

  deprecate! date: "2023-12-17", because: :discontinued

  auto_updates true

  app "Pathephone.app"

  zap trash: [
    "~LibraryApplication SupportPathephone",
    "~LibraryLogsPathephone",
    "~LibraryPreferencesspace.metabin.pathephone.helper.plist",
    "~LibraryPreferencesspace.metabin.pathephone.plist",
    "~LibrarySaved Application Statespace.metabin.pathephone.savedState",
  ]
end