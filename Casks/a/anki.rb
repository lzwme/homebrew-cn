cask "anki" do
  arch arm: "apple", intel: "intel"

  version "23.12"

  on_catalina :or_older do
    sha256 "c74c1c660e45f29fbd7b939de3cec6a8cbff2ea143ba3e27b0a807a48290ff37"

    url "https:github.comankitectsankireleasesdownload#{version}anki-#{version}-mac-#{arch}-qt5.dmg",
        verified: "github.comankitectsanki"
  end
  on_big_sur :or_newer do
    sha256 arm:   "4bcfe84739cecd3e8645a83466e566daae1f750c24db36a8bb681ca223c2b877",
           intel: "568c2f302c7dbce3a668a62154f7b5a309d9c71614b764a8c2f6f67d85ba8e6f"

    url "https:github.comankitectsankireleasesdownload#{version}anki-#{version}-mac-#{arch}-qt6.dmg",
        verified: "github.comankitectsanki"
  end

  name "Anki"
  desc "Memory training application"
  homepage "https:apps.ankiweb.net"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :high_sierra"

  app "Anki.app"

  zap trash: "~LibraryApplication SupportAnki*"
end