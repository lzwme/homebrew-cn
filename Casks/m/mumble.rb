cask "mumble" do
  version "1.4.287"
  sha256 "4294f6a1216f201c66cb94e6753d61df6f39c6a51041a9c746c6dda9f591e107"

  url "https:github.commumble-voipmumblereleasesdownloadv#{version}mumble_client-#{version}.x64.dmg",
      verified: "github.commumble-voipmumble"
  name "Mumble"
  desc "Open-source, low-latency, high quality voice chat software for gaming"
  homepage "https:wiki.mumble.infowikiMain_Page"

  livecheck do
    url "https:dl.mumble.infolateststableclient-macos-x64"
    strategy :header_match
  end

  conflicts_with cask: "homebrewcask-versionsmumble-snapshot"
  depends_on macos: ">= :high_sierra"

  app "Mumble.app"

  zap trash: [
    "~LibraryApplication SupportMumble",
    "~LibraryLogsMumble.log",
    "~LibraryPreferencesnet.sourceforge.mumble.Mumble.plist",
    "~LibrarySaved Application Statenet.sourceforge.mumble.Mumble.savedState",
    "LibraryScriptingAdditionsMumbleOverlay.osax",
  ]
end