cask "lagrange" do
  arch arm: "11.0-arm64", intel: "10.13-x86_64"

  version "1.18.0"
  sha256 arm:   "f5a860dd7df1eea754f965345e6ca95cbe568cf478016950483c0327e2e62b3c",
         intel: "9ee7bdb28c811cd327843c6ecae0a7f82efa8e8316c71f09d0ff486d5405a0bd"

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