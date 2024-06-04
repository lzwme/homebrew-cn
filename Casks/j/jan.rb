cask "jan" do
  arch arm: "arm64", intel: "x64"

  version "0.5.0"
  sha256 arm:   "9366fc919257b71b17f80ed7bde4565d43f9dc92992c0b6cf26dd229c6f06583",
         intel: "de4d612d356e9b4f13399a70fe947178f9c6e143b25e2dbda81795a0c7dd1e70"

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