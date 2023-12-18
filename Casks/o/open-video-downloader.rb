cask "open-video-downloader" do
  version "2.5.4"
  sha256 "a1c10401771c2526b47777d075fecf0401068ed40f3d3a524d52ec7e2405e769"

  url "https:github.comStefanLobbenmeieryoutube-dl-guireleasesdownloadv#{version}Open-Video-Downloader-#{version}-universal.dmg"
  name "Open Video Downloader"
  desc "Cross-platform GUI for youtube-dl made in Electron and node.js"
  homepage "https:github.comStefanLobbenmeieryoutube-dl-gui"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "Open Video Downloader.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.jelleglebbeek.youtube-dl-gui.*",
    "~LibraryPreferencescom.jelleglebbeek.youtube-dl-gui.plist",
    "~LibrarySaved Application Statecom.jelleglebbeek.youtube-dl-gui.savedState",
  ]
end