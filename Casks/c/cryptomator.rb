cask "cryptomator" do
  arch arm: "-arm64", intel: "-x64"

  version "1.14.2"
  sha256 arm:   "73de6201a7502705d8cbf36ebd3d642b37fae9be73c230e9c2edd3a85cca7324",
         intel: "dea670a4cd9b2f55cc3608a564f6ea55cbbb6625b8d63dd88a6095b970052685"

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