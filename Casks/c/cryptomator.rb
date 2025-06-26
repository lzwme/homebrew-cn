cask "cryptomator" do
  arch arm: "-arm64", intel: "-x64"

  version "1.17.0"
  sha256 arm:   "03f45e203204e93b39925cbb04e19c9316da4f77debaba4fb5071f0ec8e727e8",
         intel: "69f93bafe0707a1210089205a99936da5431cca70fdc5fa290f2b02631270580"

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