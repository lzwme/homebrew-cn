cask "macs-fan-control" do
  version "1.5.16"
  sha256 "a8a6df38ddb1de83df768bbf8cada53bee082ee385973b1e14d7f752db29cccd"

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