cask "scoot" do
  version "1.2"
  sha256 "99fb59e9f4e94b9094c4d219c6f376b36a5cb29057b032adc354eda6582c2883"

  url "https:github.commjrussoscootreleasesdownloadv#{version}Scoot.app.zip"
  name "Scoot"
  desc "Keyboard-driven cursor actuator"
  homepage "https:github.commjrussoscoot"

  app "Scoot.app"

  zap trash: [
    "~LibraryApplication Scriptscom.mjrusso.Scoot",
    "~LibraryContainerscom.mjrusso.Scoot",
    "~LibraryPreferencescom.mjrusso.Scoot.plist",
  ]
end