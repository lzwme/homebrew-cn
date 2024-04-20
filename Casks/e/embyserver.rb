cask "embyserver" do
  version "4.8.4.0"
  sha256 "84f6c5161a699076e997c3e7a214b566685564a78c7a4644e77bed969dbd635b"

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