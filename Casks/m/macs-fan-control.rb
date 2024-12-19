cask "macs-fan-control" do
  version "1.5.17"
  sha256 "db659ef42c2553616817a3d92e61aaee6f20d18df98caba9d9fba73b26c1f9cf"

  url "https:github.comcrystalideamacs-fan-controlreleasesdownloadv#{version}macsfancontrol.zip",
      verified: "github.comcrystalideamacs-fan-control"
  name "Macs Fan Control"
  desc "Controls and monitors all fans on Apple computers"
  homepage "https:crystalidea.commacs-fan-control"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "Macs Fan Control.app"

  uninstall signal: ["TERM", "com.crystalidea.MacsFanControl"]

  zap trash: "~LibraryPreferencescom.crystalidea.macsfancontrol.plist"
end