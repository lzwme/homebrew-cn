cask "keystore-explorer" do
  version "5.5.2"
  sha256 "5ef7573cda01e3db0d8ffc0e285634b600011ae0b0ea307355bb844a99dc3b5a"

  url "https:github.comkaikramerkeystore-explorerreleasesdownloadv#{version}kse-#{version.no_dots}.dmg",
      verified: "github.comkaikramerkeystore-explorer"
  name "KeyStore Explorer"
  desc "GUI replacement for the Java command-line utilities keytool and jarsigner"
  homepage "https:keystore-explorer.org"

  app "KeyStore Explorer.app"

  zap trash: "~LibrarySaved Application Stateorg.kse.keystore-explorer.savedState"
end