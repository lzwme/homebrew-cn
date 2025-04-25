cask "anki" do
  arch arm: "apple", intel: "intel"

  on_catalina :or_older do
    version "24.11"
    sha256 "4d44b763ea114e2aae61aaaa8171fd54a9095a06cd8e84a863675b1bbc75a24a"

    url "https:github.comankitectsankireleasesdownload#{version}anki-#{version}-mac-#{arch}-qt5.dmg",
        verified: "github.comankitectsanki"

    livecheck do
      skip "Legacy version"
    end
  end
  on_big_sur :or_newer do
    version "25.02.4"
    sha256 arm:   "e5cc1ca0ac696de1a805633fe3ada5a08f61c142a0ea2417e958ecc08f2703b5",
           intel: "d82e00132d7c90fe25dae391a85cfba50be2e3098ba98172281249336e832332"

    url "https:github.comankitectsankireleasesdownload#{version}anki-#{version}-mac-#{arch}-qt6.dmg",
        verified: "github.comankitectsanki"

    livecheck do
      url :url
      strategy :github_latest
    end
  end

  name "Anki"
  desc "Memory training application"
  homepage "https:apps.ankiweb.net"

  depends_on macos: ">= :high_sierra"

  app "Anki.app"

  zap trash: [
    "~LibraryApplication SupportAnki*",
    "~LibraryCachesAnki",
    "~LibrarySaved Application Statenet.ankiweb.dtop.savedState",
  ]
end