cask "pomatez" do
  arch arm: "arm64", intel: "x64"

  version "1.6.4"
  sha256 arm:   "3a32cc7db91a4b6a6e7790f77526df3410a7ab5dcdc26b0c54a1891d012c502a",
         intel: "4d7f0d96fb7b29b43332781481969aeb1f26cb33445316795eca4384f5bfe052"

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
    "~LibraryApplication Supportpomatez",
    "~LibraryApplication SupportCrashReporterPomatez_*.plist",
    "~LibraryLogspomatez",
    "~LibraryPreferencescom.roldanjr.pomatez.plist",
    "~LibrarySaved Application Statecom.roldanjr.pomatez.savedState",
  ]
end