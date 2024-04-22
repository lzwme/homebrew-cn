cask "maestral" do
  version "1.9.3"
  sha256 "79f3c0603e04fcc8762feb593349a76063f561ef5feb8d62060fbc862664aa40"

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