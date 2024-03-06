cask "jan" do
  arch arm: "arm64", intel: "x64"

  version "0.4.7"
  sha256 arm:   "117c983fd17475f88ecb0ea554bdac548e5b7d8a449fecb7e0caab8f58b9d482",
         intel: "33aa73fa9bf6c0d4e2f401f2a344158a6648a29922bdce52eb0976a44a3431d1"

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