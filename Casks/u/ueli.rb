cask "ueli" do
  arch arm: "-arm64"

  version "9.10.1"
  sha256 intel: "2bcd1ee98fdc3ba9feb1fa52b15cd7a0767adb5f61027533ed241478f6eed0b9",
         arm:   "3457790c57824f123bed39164db91bd8224670d922de61de2556cf88cb79ecfa"

  url "https:github.comoliverschwendeneruelireleasesdownloadv#{version}Ueli-#{version}#{arch}.dmg",
      verified: "github.comoliverschwendenerueli"
  name "Ueli"
  desc "Keystroke launcher"
  homepage "https:ueli.app"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "ueli.app"

  uninstall quit: "ueli"

  zap trash: [
    "~LibraryApplication Supportueli",
    "~LibraryLogsueli",
    "~LibraryPreferencescom.electron.ueli.plist",
  ]
end