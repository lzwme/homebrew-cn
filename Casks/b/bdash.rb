cask "bdash" do
  version "1.16.3"
  sha256 "95d3b065b174ec6dd8dcc02090600e623566e93fe68b20782a4b0dce842d2079"

  url "https:github.combdash-appbdashreleasesdownloadv#{version}Bdash-#{version}-mac.zip"
  name "Bdash"
  desc "Simple SQL Client for lightweight data analysis"
  homepage "https:github.combdash-appbdash"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Bdash.app"

  zap trash: [
    "~.bdash",
    "~LibraryApplication SupportBdash",
    "~LibraryLogsBdash",
    "~LibraryPreferencesio.bdash.plist",
    "~LibrarySaved Application Stateio.bdash.savedState",
  ]

  caveats do
    requires_rosetta
  end
end