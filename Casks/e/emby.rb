cask "emby" do
  version "2.2.19,25"
  sha256 :no_check

  url "https:github.comMediaBrowserEmby.ReleasesrawmastermacosEmby.app.zip",
      verified: "github.comMediaBrowserEmby.Releases"
  name "Emby"
  desc "Client for emby media server"
  homepage "https:emby.media"

  livecheck do
    url :url
    strategy :extract_plist
  end

  depends_on macos: ">= :catalina"

  app "Emby.app"

  zap trash: [
    "~LibraryApplication Scriptscom.emby.mobile",
    "~LibraryApplication Scriptsgroup.com.emby.mobile",
    "~LibraryContainerscom.emby.mobile",
    "~LibraryGroup Containersgroup.com.emby.mobile",
    "~LibrarySaved Application Statecom.emby.mobile.savedState",
  ]
end