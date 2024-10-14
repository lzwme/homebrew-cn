cask "lagrange" do
  arch arm: "11.0-arm64", intel: "10.13-x86_64"

  version "1.18.2"
  sha256 arm:   "a29a6b7fe8d8af1c7c48c06aa1cbe3f2524df4f0fd91a443c47372fb8cbaa052",
         intel: "a5fbead6544da83097751d061ce8d9d70f77247c6301f9a80d2c80a83547906f"

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