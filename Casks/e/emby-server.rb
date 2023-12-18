cask "emby-server" do
  version "4.7.14.0"
  sha256 "1331ba4a00c8d3fa261463629d0460b127ac12360f0d08f3a6e67a43408220e2"

  url "https:github.comMediaBrowserEmby.Releasesreleasesdownload#{version}embyserver-osx-x64-#{version}.zip",
      verified: "github.comMediaBrowserEmby.Releases"
  name "Emby Server"
  desc "Personal media server with apps on just about every device"
  homepage "https:emby.media"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :high_sierra"

  app "EmbyServer.app"

  zap trash: "~.configemby-server"
end