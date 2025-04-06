cask "nuclear" do
  arch arm: "arm64", intel: "x64"

  version "0.6.46"
  sha256 arm:   "fe6a3a1f7fb584525e843cc87453150fa2e39dc5f01d7c2e0034c44c62f40c2f",
         intel: "02ba7d6b478a4deaf26f02f69632441d3dc0344280ba527795eacb6384daf668"

  url "https:github.comnukeopnuclearreleasesdownloadv#{version}nuclear-v#{version}-#{arch}.dmg",
      verified: "github.comnukeopnuclear"
  name "Nuclear"
  desc "Streaming music player"
  homepage "https:nuclear.js.org"

  livecheck do
    url :url
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  app "nuclear.app"

  zap trash: [
    "~LibraryApplication Supportnuclear",
    "~LibraryLogsnuclear",
    "~LibraryPreferencesnuclear.plist",
    "~LibrarySaved Application Statenuclear.savedState",
  ]
end