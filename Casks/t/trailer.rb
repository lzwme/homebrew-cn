cask "trailer" do
  version "1.8.11"
  sha256 "6b37ea88be391ba071200d45b1ba2cfde5acf351c84b0665fc9a38e2ecae94bc"

  url "https://ghfast.top/https://github.com/ptsochantaris/trailer/releases/download/#{version}/Trailer-#{version.no_dots}.zip",
      verified: "github.com/ptsochantaris/trailer/"
  name "Trailer"
  desc "Managing Pull Requests and Issues For GitHub & GitHub Enterprise"
  homepage "https://ptsochantaris.github.io/trailer/"

  livecheck do
    url "https://ptsochantaris.github.io/trailer/appcast.xml"
    strategy :sparkle, &:short_version
  end

  no_autobump! because: :requires_manual_review

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "Trailer.app"

  uninstall quit: "com.housetrip.Trailer"

  zap trash: [
    "~/Library/Application Support/com.housetrip.Trailer",
    "~/Library/Caches/com.housetrip.Trailer",
    "~/Library/Group Containers/group.Trailer",
    "~/Library/Preferences/com.housetrip.Trailer.plist",
  ]
end