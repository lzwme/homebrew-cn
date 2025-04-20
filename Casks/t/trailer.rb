cask "trailer" do
  version "1.8.11"
  sha256 "6b37ea88be391ba071200d45b1ba2cfde5acf351c84b0665fc9a38e2ecae94bc"

  url "https:github.comptsochantaristrailerreleasesdownload#{version}Trailer-#{version.no_dots}.zip",
      verified: "github.comptsochantaristrailer"
  name "Trailer"
  desc "Managing Pull Requests and Issues For GitHub & GitHub Enterprise"
  homepage "https:ptsochantaris.github.iotrailer"

  livecheck do
    url "https:ptsochantaris.github.iotrailerappcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "Trailer.app"

  uninstall quit: "com.housetrip.Trailer"

  zap trash: [
    "~LibraryApplication Supportcom.housetrip.Trailer",
    "~LibraryCachescom.housetrip.Trailer",
    "~LibraryGroup Containersgroup.Trailer",
    "~LibraryPreferencescom.housetrip.Trailer.plist",
  ]
end