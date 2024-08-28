cask "mongodb-compass@beta" do
  arch arm: "arm64", intel: "x64"

  version "1.44.0-beta.1"
  sha256 arm:   "df57bcbe5cbafbf69c378c822cb4fa73f42018de94de780f89e1a55bb140084d",
         intel: "022974857e520567fcd40349089eb5e4543b640d7787f1fef276ddf29fc747a0"

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