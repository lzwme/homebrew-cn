cask "warzone-2100" do
  version "4.5.4"
  sha256 "f7d08cc798ca775dc1143aa037bc84ada1492b72d2d5bd1590107a396e2011bd"

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