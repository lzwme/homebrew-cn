cask "mumble" do
  version "1.5.634"
  sha256 "74556f79a48b6a9fef3c5d8458915d80f38e55384fe02db5fbd5df37c87ca387"

  url "https:github.commumble-voipmumblereleasesdownloadv#{version}mumble_client-#{version}.x64.dmg",
      verified: "github.commumble-voipmumble"
  name "Mumble"
  desc "Open-source, low-latency, high quality voice chat software for gaming"
  homepage "https:www.mumble.info"

  livecheck do
    url "https:dl.mumble.infolateststableclient-macos-x64"
    strategy :header_match
  end

  conflicts_with cask: "mumble@snapshot"
  depends_on macos: ">= :high_sierra"

  app "Mumble.app"

  zap trash: [
    "LibraryScriptingAdditionsMumbleOverlay.osax",
    "~LibraryApplication SupportMumble",
    "~LibraryLogsMumble.log",
    "~LibraryPreferencesnet.sourceforge.mumble.Mumble.plist",
    "~LibrarySaved Application Statenet.sourceforge.mumble.Mumble.savedState",
  ]

  caveats do
    requires_rosetta
  end
end