cask "mongodb-compass@beta" do
  arch arm: "arm64", intel: "x64"

  version "1.44.0-beta.4"
  sha256 arm:   "ce4a139d6350b7d626c8aaa11c8a8b2c1d5d5532e299e6f23990015be61662d0",
         intel: "e3d7be065e2cff481aa4bb0374273f49e4c10f3ac5a4d10ef29e554c98e2bc60"

  url "https:downloads.mongodb.comcompassbetamongodb-compass-#{version}-darwin-#{arch}.dmg"
  name "MongoDB Compass"
  desc "GUI for MongoDB"
  homepage "https:www.mongodb.comtrydownloadcompass"

  livecheck do
    url "https:github.commongodb-jscompassreleases?q=prerelease%3Atrue&expanded=true"
    regex(%r{href=["']?[^"' >]*?tag\D*?(\d+(?:\.\d+)+-beta\.\d)[^"' >]*?["' >]}i)
    strategy :page_match
  end

  depends_on macos: ">= :catalina"

  app "MongoDB Compass Beta.app"

  zap trash: [
    "~.mongodb",
    "~LibraryApplication SupportMongoDB Compass Beta",
    "~LibraryPreferencescom.mongodb.compass.beta.plist",
    "~LibrarySaved Application Statecom.mongodb.compass.beta.savedState",
  ]
end