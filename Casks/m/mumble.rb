cask "mumble" do
  version "1.5.735"
  sha256 "9f7e5f0677e577a480269df218349dca4263a3785461294f3c8f26ca4c308641"

  url "https:github.commumble-voipmumblereleasesdownloadv#{version}mumble_client-#{version}.x64.dmg",
      verified: "github.commumble-voipmumble"
  name "Mumble"
  desc "Open-source, low-latency, high quality voice chat software for gaming"
  homepage "https:www.mumble.info"

  livecheck do
    url "https:dl.mumble.infolateststableclient-macos-x64"
    strategy :header_match
  end

  no_autobump! because: :requires_manual_review

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