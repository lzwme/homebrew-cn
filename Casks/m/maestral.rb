cask "maestral" do
  version "1.8.0"
  sha256 "19e8a8c2985599dbfdf0eff2c1fa0cde2caf012ee5242a3bb3e8686b6d1873b6"

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