cask "keystore-explorer" do
  version "5.5.3"
  sha256 "b7294dd814bc339e51e9884657e9919f907def1b8c4ce3546c6ecba5f9d81d9f"

  url "https:github.comkaikramerkeystore-explorerreleasesdownloadv#{version}kse-#{version.no_dots}.dmg",
      verified: "github.comkaikramerkeystore-explorer"
  name "KeyStore Explorer"
  desc "GUI replacement for the Java command-line utilities keytool and jarsigner"
  homepage "https:keystore-explorer.org"

  app "KeyStore Explorer.app"

  zap trash: "~LibrarySaved Application Stateorg.kse.keystore-explorer.savedState"
end