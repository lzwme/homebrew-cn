cask "camera-live" do
  version "11"
  sha256 "4c7a6ecdbec677a6fbbb90af427e54b0d429278c87b49966c6448ce065c78e75"

  url "https:github.comv002v002-Camera-Livereleasesdownload#{version}Camera.Live.zip"
  name "Camera Live"
  desc "Syphon server for connected Canon DSLR cameras"
  homepage "https:github.comv002v002-Camera-Live"

  livecheck do
    url :url
    regex(v?(\d+)i)
    strategy :github_latest
  end

  app "Camera Live.app"

  zap trash: [
    "~LibraryPreferencesinfo.v002.Camera-Live.plist",
    "~LibrarySaved Application Stateinfo.v002.Camera-Live.savedState",
  ]
end