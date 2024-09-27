cask "yaak" do
  arch arm: "aarch64", intel: "x64"

  version "2024.10.1"
  sha256 arm:   "98b2583e16c2c75449e6e470915bf8ee0ccd75c2bf3aa37833f5715fef0393df",
         intel: "77251581ebea3062949be722c16d71db60070b1331c375b7e15c9e6e65d72d8c"

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

  depends_on macos: ">= :high_sierra"

  app "yaak.app"

  zap trash: [
    "~LibraryApplication Supportapp.yaak.desktop",
    "~LibraryCachesapp.yaak.desktop",
    "~LibraryLogsapp.yaak.desktop",
    "~LibrarySaved Application Stateapp.yaak.desktop.savedState",
    "~LibraryWebkitapp.yaak.desktop",
  ]
end