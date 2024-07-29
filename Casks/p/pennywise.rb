cask "pennywise" do
  version "0.8.0"
  sha256 "9e6195f1096d399aafd77da74e4461964364fdbeec3b667cd91ecf9704e73b69"

  url "https:github.comkamranahmedsepennywisereleasesdownloadv#{version}Pennywise-#{version}.dmg"
  name "Pennywise"
  homepage "https:github.comkamranahmedsepennywise"

  deprecate! date: "2024-07-28", because: :unmaintained

  app "Pennywise.app"

  zap trash: [
    "~LibraryApplication SupportPennywise",
    "~LibraryLogsPennywise",
    "~LibraryPreferencesinfo.kamranahmed.pennywise.plist",
    "~LibrarySaved Application Stateinfo.kamranahmed.pennywise.savedState",
  ]

  caveats do
    requires_rosetta
  end
end