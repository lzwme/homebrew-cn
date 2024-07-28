cask "mellow" do
  version "0.1.22"
  sha256 "f8b168fb1a491032a4c56df3350e67db3a32a94beeeeeae4e17e6ce426002099"

  url "https:github.commellow-iomellowreleasesdownloadv#{version}Mellow-#{version}.dmg"
  name "Mellow"
  desc "Rule-based global transparent proxy client"
  homepage "https:github.commellow-iomellow"

  deprecate! date: "2024-07-27", because: :unmaintained

  app "Mellow.app"

  zap trash: [
    "LibraryApplication SupportMellow",
    "~LibraryLogsMellow",
    "~LibraryPreferencesorg.mellow.mellow.plist",
  ]

  caveats do
    requires_rosetta
  end
end