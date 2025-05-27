cask "pomatez" do
  arch arm: "arm64", intel: "x64"

  version "1.8.0"
  sha256 arm:   "d8093fccf2030a29fa46c11c564551e76ce6a5e21cb03367e5ce24d7de880fc2",
         intel: "857054dce08f946b2de4a44704d87026e7655f553f9c941ee857ff168dbe153c"

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