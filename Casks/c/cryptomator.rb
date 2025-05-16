cask "cryptomator" do
  arch arm: "-arm64", intel: "-x64"

  version "1.16.2"
  sha256 arm:   "10d6065b8797da3b6ba248f2d854ff4c9f88bbb1ffd1aef83ba774408cf91641",
         intel: "64b91c21ba9dc33a4a865aed2b29a622cd732cb4c0731242359d71972df7f18a"

  url "https:github.comcryptomatorcryptomatorreleasesdownload#{version}Cryptomator-#{version}#{arch}.dmg",
      verified: "github.comcryptomatorcryptomator"
  name "Cryptomator"
  desc "Multi-platform client-side cloud file encryption tool"
  homepage "https:cryptomator.org"

  livecheck do
    url "https:api.cryptomator.orgdesktoplatest-version.json"
    strategy :json do |json|
      json["mac"]
    end
  end

  depends_on macos: ">= :big_sur"

  app "Cryptomator.app"

  zap trash: [
    "~LibraryApplication SupportCryptomator",
    "~LibraryLogsCryptomator",
    "~LibraryPreferencesorg.cryptomator.plist",
  ]
end