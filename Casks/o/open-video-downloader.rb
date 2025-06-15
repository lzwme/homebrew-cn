cask "open-video-downloader" do
  version "2.5.5"
  sha256 "18ca0f13e42002983c11807b52aa55948f02ef876fb51c72b9893c774521974b"

  url "https:github.comStefanLobbenmeieryoutube-dl-guireleasesdownloadv#{version}Open-Video-Downloader-#{version}-universal.dmg"
  name "Open Video Downloader"
  desc "Cross-platform GUI for youtube-dl made in Electron and node.js"
  homepage "https:github.comStefanLobbenmeieryoutube-dl-gui"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "Open Video Downloader.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.jelleglebbeek.youtube-dl-gui.*",
    "~LibraryPreferencescom.jelleglebbeek.youtube-dl-gui.plist",
    "~LibrarySaved Application Statecom.jelleglebbeek.youtube-dl-gui.savedState",
  ]
end