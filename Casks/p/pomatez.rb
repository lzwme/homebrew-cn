cask "pomatez" do
  arch arm: "arm64", intel: "x64"

  version "1.7.2"
  sha256 arm:   "bd8b4b3324c1b5b72468c0b23c782789c116cbac4a36cc59f04965b35b3f06b4",
         intel: "e97d5f67339c1188b8aa7350ca923c6b0b99dd42d3dea00dfdbcad3efca9b3ea"

  url "https:github.comzidoropomatezreleasesdownloadv#{version}Pomatez-v#{version}-mac-#{arch}.dmg",
      verified: "github.comzidoropomatez"
  name "Pomatez"
  desc "Pomodoro timer"
  homepage "https:zidoro.github.iopomatez"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Pomatez.app"

  uninstall signal: ["KILL", "application.com.roldanjr.pomatez"]

  zap trash: [
    "~LibraryApplication SupportCrashReporterPomatez_*.plist",
    "~LibraryApplication Supportpomatez",
    "~LibraryLogspomatez",
    "~LibraryPreferencescom.roldanjr.pomatez.plist",
    "~LibrarySaved Application Statecom.roldanjr.pomatez.savedState",
  ]
end