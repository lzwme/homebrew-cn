cask "smcfancontrol" do
  version "2.6"
  sha256 "7662058e618537eb466307e3b12e540b857e61392646a5b09df51bec9ad6da38"

  url "https:github.comhholtmannsmcFanControlreleasesdownload#{version}smcfancontrol_#{version.dots_to_underscores}.zip"
  name "smcFanControl"
  desc "Sets a minimum speed for built-in fans"
  homepage "https:github.comhholtmannsmcFanControl"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "smcFanControl.app"

  zap trash: [
    "~LibraryApplication SupportsmcFanControl",
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.eidac.smcfancontrol#{version.major}.sfl*",
    "~LibraryCachescom.eidac.smcFanControl#{version.major}",
    "~LibraryPreferencescom.eidac.smcFanControl#{version.major}.plist",
  ]
end