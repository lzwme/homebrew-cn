cask "laravel-kit" do
  arch arm: "-arm64"

  version "2.0.8"
  sha256 arm:   "f5cc20ce507ca6bef4e6de99d7e00aee12f55d9ef01dab85be7f1a6074b8a045",
         intel: "fb748da7a99911a7b182ac7958862dfa1a9e036ec82529a2fb65e4b768c72b1a"

  url "https:github.comtmdhlaravel-kitreleasesdownloadv#{version}Laravel-Kit-#{version}#{arch}-mac.zip",
      verified: "github.comtmdhlaravel-kit"
  name "Laravel Kit"
  desc "Desktop Laravel admin panel app"
  homepage "https:tmdh.github.iolaravel-kit"

  depends_on macos: ">= :high_sierra"

  app "Laravel Kit.app"

  zap trash: [
    "~LibraryApplication Supportlaravel-kit",
    "~LibraryPreferencescom.tmdh.laravel-kit.plist",
    "~LibrarySaved Application Statecom.tmdh.laravel-kit.savedState",
  ]
end