cask "jubler" do
  version "8.0.0"
  sha256 "f834a5396d8b612fda0aba21d576f8c2d487977bac518f637675d37b9b7ef497"

  url "https:github.comterasJublerreleasesdownloadv#{version}Jubler-#{version}.dmg",
      verified: "github.comterasJubler"
  name "Jubler"
  desc "Subtitle editor"
  homepage "https:www.jubler.org"

  app "Jubler.app"

  zap trash: [
    "~LibraryApplication SupportJubler",
    "~LibraryPreferencescom.panayotis.jubler.config",
    "~LibraryPreferencescom.panayotis.jubler.config.old",
    "~LibraryPreferencescom.panayotis.jubler.plist",
  ]
end