cask "iglance" do
  version "2.1.0"
  sha256 "3cc56893ae4d05b0931122028f5787448e5c0ffca5be3939c200c385188163b7"

  url "https:github.comiglanceiglancereleasesdownloadv#{version}iGlance_v#{version}.zip"
  name "iGlance"
  desc "System monitor for the status bar"
  homepage "https:github.comiglanceiGlance"

  auto_updates true
  depends_on macos: ">= :sierra"

  app "iGlance.app"

  zap trash: [
    "~LibraryCachesio.github.iglance.iGlance",
    "~LibraryPreferencesio.github.iglance.iGlance.plist",
  ]
end