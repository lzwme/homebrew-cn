cask "anki" do
  arch arm: "apple", intel: "intel"

  version "24.11"

  on_catalina :or_older do
    sha256 "939eff95f5dbefffaeba3abfd549ec86e195542190da6fe33c429c4c5a84abb1"

    url "https:github.comankitectsankireleasesdownload#{version}anki-#{version}-mac-#{arch}-qt5.dmg",
        verified: "github.comankitectsanki"
  end
  on_big_sur :or_newer do
    sha256 arm:   "004a72ad9050fb4148f42c7009a70695b303319ede79b0513e443436cb6e6e79",
           intel: "77de257e4d695098319380f2970f9f0b6aadf307d127bb494189be0a1a752799"

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