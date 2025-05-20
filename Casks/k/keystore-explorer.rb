cask "keystore-explorer" do
  arch arm: "arm64", intel: "x64"

  version "5.6.0"
  sha256 arm:   "3bc193e6f9f644ad9d81b1493d2250a190af6c83b3f11accbe05676d9e50fcf9",
         intel: "adbc55d3b04f8987875c859a36d0190e4f779b2c58a23abed20143063c5accdc"

  url "https:github.comkaikramerkeystore-explorerreleasesdownloadv#{version}kse-#{version.no_dots}-#{arch}.dmg",
      verified: "github.comkaikramerkeystore-explorer"
  name "KeyStore Explorer"
  desc "GUI replacement for the Java command-line utilities keytool and jarsigner"
  homepage "https:keystore-explorer.org"

  livecheck do
    url "https:keystore-explorer.orgversion.txt"
    regex((\d+(?:\.\d+)+)i)
  end

  app "KeyStore Explorer.app"

  zap trash: "~LibrarySaved Application Stateorg.kse.keystore-explorer.savedState"
end