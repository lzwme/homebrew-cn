cask "camera-live" do
  version "11"
  sha256 "4c7a6ecdbec677a6fbbb90af427e54b0d429278c87b49966c6448ce065c78e75"

  url "https:github.comv002v002-Camera-Livereleasesdownload#{version}Camera.Live.zip"
  name "Camera Live"
  desc "Syphon server for connected Canon DSLR cameras"
  homepage "https:github.comv002v002-Camera-Live"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-07-28", because: :discontinued

  app "Camera Live.app"

  zap trash: [
    "~LibraryPreferencesinfo.v002.Camera-Live.plist",
    "~LibrarySaved Application Stateinfo.v002.Camera-Live.savedState",
  ]

  caveats do
    requires_rosetta
  end
end