cask "quassel" do
  version "0.14.0"
  sha256 "cb8b195cd9961c8af26a9df7f5411aa1f23324d1ee717f7c4df8abc2b70021a2"

  url "https:github.comquasselquasselreleasesdownload#{version}QuasselMono-MacOS-#{version}.dmg",
      verified: "github.comquasselquassel"
  name "Quassel"
  desc "IRC client"
  homepage "https:quassel-irc.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :high_sierra"

  app "Quassel.app"

  zap trash: [
    "~LibraryApplication SupportQuassel",
    "~LibraryPreferencesorg.quassel-irc.quasselclient.plist",
    "~LibraryPreferencesorg.quassel-irc.quasselcore.plist",
    "~LibrarySaved Application Stateorg.quassel-irc.client.savedState",
  ]

  caveats do
    requires_rosetta
  end
end