cask "mongodb-compass@beta" do
  arch arm: "arm64", intel: "x64"

  version "1.43.5-beta.0"
  sha256 arm:   "b18b1c003884924a8e6d1d018bc4d5c1d6c9e3653cf2b9186d52e80ae6d36bb1",
         intel: "aeb27d05d44e85a5677d3e8aa83b4be9c0a8f7626fde409d4157ad5f4cf57c6b"

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