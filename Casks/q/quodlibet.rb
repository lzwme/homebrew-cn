cask "quodlibet" do
  version "4.4.0"
  sha256 "e06e1026e57699b6533fa0787da404c3dfdd3056eefcfcfce7a4a5be7f67b081"

  url "https:github.comquodlibetquodlibetreleasesdownloadrelease-#{version}QuodLibet-#{version}.dmg",
      verified: "github.comquodlibetquodlibet"
  name "Quod Libet"
  desc "Music player and music library manager"
  homepage "https:quodlibet.readthedocs.io"

  livecheck do
    url "https:quodlibet.github.ioappcastosx-quodlibet.rss"
    strategy :sparkle
  end

  no_autobump! because: :requires_manual_review

  auto_updates true

  app "QuodLibet.app"

  zap trash: [
    "~.quodlibet",
    "~LibraryPreferencesio.github.quodlibet.quodlibet.plist",
    "~LibrarySaved Application Stateio.github.quodlibet.quodlibet.savedState",
  ]
end