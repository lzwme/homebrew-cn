cask "maestral" do
  version "1.9.4"
  sha256 "639ab2401d97fad7865ba17ce8cfa02fb418d3bb29cd411cf991cce91c51b1ea"

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
  depends_on macos: ">= :big_sur"

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