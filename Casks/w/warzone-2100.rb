cask "warzone-2100" do
  version "4.5.1"
  sha256 "969aafa937d5198cbe0f7d968ba6182b02e51051332cf0f08976221b57e8a220"

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