cask "macs-fan-control" do
  version "1.5.18"
  sha256 "8738185f57dcef93a4780cc58c78bbbd852484cb5a2a9a38cb9c3ee3c85e35d1"

  url "https:github.comcrystalideamacs-fan-controlreleasesdownloadv#{version}macsfancontrol.zip",
      verified: "github.comcrystalideamacs-fan-control"
  name "Macs Fan Control"
  desc "Controls and monitors all fans on Apple computers"
  homepage "https:crystalidea.commacs-fan-control"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "Macs Fan Control.app"

  uninstall signal: ["TERM", "com.crystalidea.MacsFanControl"]

  zap trash: "~LibraryPreferencescom.crystalidea.macsfancontrol.plist"
end