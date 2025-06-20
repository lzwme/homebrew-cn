cask "xemu" do
  version "0.8.75"
  sha256 "80586885d9b16b378a7167f75ff827cc3822681f9402eed14c72d0ff087a6eec"

  url "https:github.comxemu-projectxemureleasesdownloadv#{version}xemu-macos-universal-release.zip",
      verified: "github.comxemu-projectxemu"
  name "Xemu"
  desc "Original Xbox Emulator"
  homepage "https:xemu.app"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Xemu.app"

  zap trash: [
    "~LibraryApplication Supportxemu",
    "~LibraryPreferencesxemu.app.0.plist",
    "~LibrarySaved Application Statexemu.app.0.savedState",
  ]
end