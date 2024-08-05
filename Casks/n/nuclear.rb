cask "nuclear" do
  arch arm: "arm64", intel: "x64"

  version "0.6.33"
  sha256 arm:   "17535559242543a0fd49a5a61a8b19ec65a2c5be66f9e6aa46dd3ecb925e9346",
         intel: "1c862bed01e78d2c34c4599e057a1050dc4faf8d92eabe6b1dc9b87d568488bd"

  url "https:github.comnukeopnuclearreleasesdownloadv#{version}nuclear-v#{version}-#{arch}.dmg",
      verified: "github.comnukeopnuclear"
  name "Nuclear"
  desc "Streaming music player"
  homepage "https:nuclear.js.org"

  livecheck do
    url :url
    regex(v?(\d+(?:\.\d+)+)i)
  end

  app "nuclear.app"

  zap trash: [
    "~LibraryApplication Supportnuclear",
    "~LibraryLogsnuclear",
    "~LibraryPreferencesnuclear.plist",
    "~LibrarySaved Application Statenuclear.savedState",
  ]
end