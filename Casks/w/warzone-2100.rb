cask "warzone-2100" do
  version "4.5.3"
  sha256 "c15a39cfab236a5d9fb279a5a3bf8fa50e84db52e25889cfe371105593935de9"

  url "https:github.comWarzone2100warzone2100releasesdownload#{version}warzone2100_macOS_universal.zip",
      verified: "github.comWarzone2100warzone2100"
  name "Warzone 2100"
  desc "Free and open-source real time strategy game"
  homepage "https:wz2100.net"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Warzone 2100.app"

  zap trash: [
    "~LibraryApplication SupportWarzone 2100*",
    "~LibrarySaved Application Statenet.wz2100.Warzone2100.savedState",
  ]
end