cask "macs-fan-control" do
  version "1.5.17"
  sha256 "ec22fe2723e9bd77efbcaaf5ba129571c049d88f7078224a0c2836e943b02ea5"

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