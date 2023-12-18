cask "beardedspice" do
  version "2.2.3"
  sha256 "3867314a5d6d8a6da40d2a0bcb11279067885acb41e3e811d8f547219c150b26"

  url "https:github.combeardedspicebeardedspicereleasesdownloadv#{version}BeardedSpice-#{version}.zip"
  name "BeardedSpice"
  homepage "https:github.combeardedspicebeardedspice"

  auto_updates true

  app "BeardedSpice.app"

  zap trash: [
    "~LibraryCachescom.beardedspice.BeardedSpice",
    "~LibraryPreferencescom.beardedspice.BeardedSpice.plist",
  ]
end