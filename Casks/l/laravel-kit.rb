cask "laravel-kit" do
  arch arm: "-arm64"

  version "2.0.9"
  sha256 arm:   "ddab08305eefb11f46009d257685b87b8649fb928afee318b1f5d7eaa7a538f8",
         intel: "5d17be67b3bfc4fedcf6de0e64e8e4a93df9b467cb8540e073c3d52b4346697d"

  url "https:github.comtmdhlaravel-kitreleasesdownloadv#{version}Laravel-Kit-#{version}#{arch}-mac.zip",
      verified: "github.comtmdhlaravel-kit"
  name "Laravel Kit"
  desc "Desktop Laravel admin panel app"
  homepage "https:tmdh.github.iolaravel-kit"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :high_sierra"

  app "Laravel Kit.app"

  zap trash: [
    "~LibraryApplication Supportlaravel-kit",
    "~LibraryPreferencescom.tmdh.laravel-kit.plist",
    "~LibrarySaved Application Statecom.tmdh.laravel-kit.savedState",
  ]
end