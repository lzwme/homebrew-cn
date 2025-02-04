cask "cryptomator" do
  arch arm: "-arm64", intel: "-x64"

  version "1.15.0"
  sha256 arm:   "ef06612b57e26690cb778d46f2e08b096a74d066708b0decdf75b966c27fcc2c",
         intel: "9e8c5eab82865174eb87afcfefb29275b671f59b599a745b4390ec50b00cb5da"

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