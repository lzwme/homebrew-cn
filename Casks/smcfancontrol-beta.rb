cask "smcfancontrol-beta" do
  version "2.6.1"
  sha256 "d9dcd2c01e2583b74e14a6303ffd75d659dea7f99e1e42de4d8fcb0115cbcec3"

  url "https:github.comhholtmannsmcFanControlreleasesdownload#{version}%C3%9F1smcFanControl_#{version.dots_to_underscores}.zip"
  name "smcFanControl"
  desc "Sets a minimum speed for built-in fans"
  homepage "https:github.comhholtmannsmcFanControl"

  livecheck do
    url :url
    regex(^v?(\d+(?:\.\d+)+)[^ß]?i)
  end

  conflicts_with cask: "smcfancontrol"

  app "smcFanControl.app"

  zap trash: [
    "~LibraryApplication SupportsmcFanControl",
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.eidac.smcfancontrol#{version.major}.sfl*",
    "~LibraryCachescom.eidac.smcFanControl#{version.major}",
  ]
end