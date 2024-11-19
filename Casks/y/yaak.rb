cask "yaak" do
  arch arm: "aarch64", intel: "x64"

  version "2024.12.1"
  sha256 arm:   "0a7c7ea0a55734096f597d925a4b44ab233fe5b748e86eb18f5e4781603b44a6",
         intel: "428b800825ddb74cd9a6fdebf7dafcf155df168fddf6bbe6cf209230cc8fa2ef"

  url "https:github.comyaakappappreleasesdownloadv#{version}Yaak_#{version}_#{arch}.dmg",
      verified: "github.comyaakappapp"
  name "Yaak"
  desc "REST, GraphQL and gRPC client"
  homepage "https:yaak.app"

  livecheck do
    url "https:update.yaak.appcheckdarwin#{arch}0"
    strategy :json do |json|
      json["version"]
    end
  end

  auto_updates true
  depends_on macos: ">= :ventura"

  app "yaak.app"

  zap trash: [
    "~LibraryApplication Supportapp.yaak.desktop",
    "~LibraryCachesapp.yaak.desktop",
    "~LibraryLogsapp.yaak.desktop",
    "~LibrarySaved Application Stateapp.yaak.desktop.savedState",
    "~LibraryWebkitapp.yaak.desktop",
  ]
end