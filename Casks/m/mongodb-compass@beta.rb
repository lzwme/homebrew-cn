cask "mongodb-compass@beta" do
  arch arm: "arm64", intel: "x64"

  version "1.43.6-beta.3"
  sha256 arm:   "3edd88696a840fe58b0c00a0e724adb827a5d0ea2c7a1f7a00d3bf7a11d17df3",
         intel: "1d88c59d25b225024f1c82b65b711f28cd497571b1d1eb5726e2cab70f6fc7c9"

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