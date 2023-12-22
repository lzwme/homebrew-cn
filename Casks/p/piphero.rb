cask "piphero" do
  arch arm: "arm64", intel: "x64"

  version "1.1.1"
  sha256 arm:   "9bcd257e85fdb26256a5c579f6378a0c043f956422cae763e8495ff0689af67f",
         intel: "092a17d31aa427583f2cee098d29c286580604a7df92d3e0416db07fe94dc534"

  url "https:github.compipheroappdownloadsreleasesdownloadv#{version}PiPHero-#{version}-mac-#{arch}.dmg",
      verified: "github.compipheroappdownloads"
  name "PiPHero"
  desc "Menu bar app to picture-in-picture any window"
  homepage "https:piphero.app"

  app "PiPHero.app"

  zap trash: [
    "~LibraryApplication Supportpiphero",
    "~LibraryPreferencescom.piphero.app.plist",
  ]
end