cask "maestral" do
  version "1.9.2"
  sha256 "24b0e575108717cd4a5cf823ea521682b623ab51f56827eaea14ceab2de2c66c"

  url "https:github.comSamSchottmaestralreleasesdownloadv#{version}Maestral-#{version}.dmg",
      verified: "github.comSamSchottmaestral"
  name "Maestral"
  desc "Open-source Dropbox client"
  homepage "https:maestral.app"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "Maestral.app"
  binary "#{appdir}Maestral.appContentsMacOSmaestral-cli", target: "maestral"

  uninstall quit: "com.samschott.maestral"

  zap trash: [
    "~LibraryApplication Supportmaestral",
    "~LibraryLaunchAgentscom.samschott.maestral.maestral.plist",
    "~LibraryLogsmaestral",
    "~LibraryPreferencescom.samschott.maestral.plist",
  ]
end