cask "mongodb-compass@beta" do
  arch arm: "arm64", intel: "x64"

  version "1.43.3-beta.0"
  sha256 arm:   "8822d6c2fcac464429581bc2cf53b2a04ee6a6128fcfb5eea1ac3ecb475428f4",
         intel: "d2ae7effd12356e1eb0d2a9ca5186ef1c5b00529f817f3fe325b7f1b73703d93"

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