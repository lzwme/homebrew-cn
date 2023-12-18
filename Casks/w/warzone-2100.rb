cask "warzone-2100" do
  version "4.4.2"
  sha256 "7cbf8c180a680a5aac2a3a8abfe9f311af4572055b88815e1a383ca66197e90d"

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