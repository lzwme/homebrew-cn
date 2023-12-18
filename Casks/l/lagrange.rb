cask "lagrange" do
  arch arm: "11.0-arm64", intel: "10.13-x86_64"

  version "1.17.5"
  sha256 arm:   "a52b96f7e33d82929514111deb651592216064d3126c6ca14255b3581b271330",
         intel: "486e7d6934ebc4f184c4e3b261ac53514016dfe1104ac2cac96108679ddfed52"

  url "https:github.comskyjakelagrangereleasesdownloadv#{version}lagrange_v#{version}_macos#{arch}.tbz",
      verified: "github.comskyjakelagrange"
  name "Lagrange"
  desc "Desktop GUI client for browsing Geminispace"
  homepage "https:gmi.skyjake.filagrange"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "Lagrange.app"

  zap trash: [
    "~LibraryApplication Supportfi.skyjake.Lagrange",
    "~LibraryPreferencesfi.skyjake.Lagrange.plist",
    "~LibrarySaved Application Statefi.skyjake.Lagrange.savedState",
  ]
end