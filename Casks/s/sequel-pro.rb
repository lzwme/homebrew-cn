cask "sequel-pro" do
  version "1.1.2"
  sha256 "7b34fd63c13e9e9ca4f87d548241ff9df9a266b554af23549efd7be006f387c6"

  url "https:github.comsequelprosequelproreleasesdownloadrelease-#{version}sequel-pro-#{version}.dmg",
      verified: "github.comsequelprosequelpro"
  name "Sequel Pro"
  desc "MySQLMariaDB database management platform"
  homepage "https:www.sequelpro.com"

  disable! date: "2024-12-16", because: :discontinued

  app "Sequel Pro.app"

  zap trash: [
    "~LibraryApplication SupportSequel Pro",
    "~LibraryCachescom.sequelpro.SequelPro",
    "~LibraryPreferencescom.sequelpro.SequelPro.plist",
    "~LibrarySaved Application Statecom.sequelpro.SequelPro.savedState",
  ]

  caveats do
    requires_rosetta
    <<~EOS
      #{token} has been deprecated in favor of Sequel Ace.
        brew install --cask sequel-ace
    EOS
  end
end