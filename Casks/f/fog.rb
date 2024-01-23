cask "fog" do
  version "1.4.5"
  sha256 "dbf1216fce69ead08e9e9a37b18391d3d65e7f06ae4e6f633e7047832c6b1adc"

  url "https:github.comvitorgalvaofogreleasesdownload#{version}Fog-#{version}-mac.zip"
  name "Fog"
  desc "Unofficial overcast.fm podcast app"
  homepage "https:github.comvitorgalvaofog"

  deprecate! date: "2023-12-17", because: :discontinued

  app "Fog.app"

  uninstall quit: "com.vitorgalvao.fog"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.vitorgalvao.fog.sfl*",
    "~LibraryApplication SupportFog",
    "~LibraryCachesFog",
    "~LibraryPreferencescom.vitorgalvao.fog.helper.plist",
    "~LibraryPreferencescom.vitorgalvao.fog.plist",
    "~LibrarySaved Application Statecom.vitorgalvao.fog.savedState",
  ]
end