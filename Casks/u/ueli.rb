cask "ueli" do
  arch arm: "-arm64"

  version "9.3.1"
  sha256 intel: "78e53be3d1e00a890c0ae7645ad7a81ff35f23381dafdcae578dacdbc624426c",
         arm:   "4f0395ec7f4b7112aea8ff4acc1e006c2a2cfb05cac1853acc60e3c316b259c3"

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