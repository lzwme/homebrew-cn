cask "ueli" do
  arch arm: "-arm64"

  version "9.18.0"
  sha256 intel: "9d5000017eec897aaad9a0967eadd8b120fe90951bbee29faa9cea3c323ca710",
         arm:   "65682d607dbdadcc4227318e15cd175509a4d4d3db61af068f4e44697371d94c"

  url "https:github.comoliverschwendeneruelireleasesdownloadv#{version}Ueli-#{version}#{arch}.dmg",
      verified: "github.comoliverschwendenerueli"
  name "Ueli"
  desc "Keystroke launcher"
  homepage "https:ueli.app"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"

  app "ueli.app"

  uninstall quit: "ueli"

  zap trash: [
    "~LibraryApplication Supportueli",
    "~LibraryLogsueli",
    "~LibraryPreferencescom.electron.ueli.plist",
  ]
end