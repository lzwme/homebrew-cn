cask "tomatobar" do
  version "3.5.0"
  sha256 "f5b29a3761d60a952697fa9f8f9e1c86350ee6f18d4e94eb2e9093ab7cb61e72"

  url "https:github.comivoroninTomatoBarreleasesdownloadv#{version}TomatoBar-v#{version}.zip"
  name "TomatoBar"
  desc "Menu bar pomodoro timer"
  homepage "https:github.comivoroninTomatoBar"

  app "TomatoBar.app"

  zap trash: [
    "~LibraryApplication Scriptscom.github.ivoronin.TomatoBar",
    "~LibraryContainerscom.github.ivoronin.TomatoBar",
  ]
end