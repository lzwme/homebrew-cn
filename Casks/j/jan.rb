cask "jan" do
  arch arm: "arm64", intel: "x64"

  version "0.4.9"
  sha256 arm:   "1d02be1041ecc8bddb770123632f2aef0b07739ae4a092b9a5003171cd116227",
         intel: "b91429553a9afcaa593b6bf396bdbb5389a045c3bff4c31ab210a05026d02810"

  url "https:github.comjanhqjanreleasesdownloadv#{version}jan-mac-#{arch}-#{version}.dmg",
      verified: "github.comjanhqjan"
  name "Jan"
  desc "Offline AI chat tool"
  homepage "https:jan.ai"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Jan.app"

  zap trash: [
    "~LibraryApplication SupportJan",
    "~LibraryPreferencesjan.ai.app.plist",
    "~LibrarySaved Application Statejan.ai.app.savedState",
  ]
end