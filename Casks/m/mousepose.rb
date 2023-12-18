cask "mousepose" do
  version "4.3,10282"
  sha256 "75151165bfeb6eb1fe6ac3835cb0c80ce0bba26559d3c5410977bf034f688883"

  url "https:cdn.boinx.comsoftwaremouseposeMousepose-#{version.csv.first}-Boinx-(#{version.csv.second}).app.zip"
  name "Mouseposé"
  desc "Highlight your mouse pointer and cursor position"
  homepage "https:boinx.commouseposeoverview"

  livecheck do
    url "https:sparkle.boinx.comappcast.lasso?appName=mousepose"
    strategy :sparkle
  end

  depends_on macos: ">= :mojave"

  # Renamed for consistency: app name is different in the Finder and in a shell.
  # Original discussion: https:github.comHomebrewhomebrew-caskpull15708
  app "Mousepose.app", target: "Mousepose\314\201.app"

  zap trash: [
    "~LibraryApplication Supportcom.boinx.Mousepose",
    "~LibraryCachescom.boinx.Mousepose",
    "~LibraryCookiescom.boinx.Mousepose.binarycookies",
    "~LibraryPreferencescom.boinx.Mousepose.plist",
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.boinx.mousepose.sfl*",
  ]
end