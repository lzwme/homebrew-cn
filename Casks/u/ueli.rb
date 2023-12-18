cask "ueli" do
  version "8.27.0"
  sha256 "4c814fc8a139997d50ce95cf9608290525cf4753aefd0312abcfe0755e5fd559"

  url "https:github.comoliverschwendeneruelireleasesdownloadv#{version}ueli-#{version}.dmg",
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