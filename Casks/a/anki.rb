cask "anki" do
  arch arm: "apple", intel: "intel"

  version "24.06.3"

  on_catalina :or_older do
    sha256 "939eff95f5dbefffaeba3abfd549ec86e195542190da6fe33c429c4c5a84abb1"

    url "https:github.comankitectsankireleasesdownload#{version}anki-#{version}-mac-#{arch}-qt5.dmg",
        verified: "github.comankitectsanki"
  end
  on_big_sur :or_newer do
    sha256 arm:   "ce2f728c98ab3711450fbc066b8fbe27e983684e5d6195be5f451475d1a48d35",
           intel: "51045da7f1a189119fb0117e995ea108aa4440616ffc8f43f4a4ed735a7befaa"

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