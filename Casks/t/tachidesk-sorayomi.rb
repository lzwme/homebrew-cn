cask "tachidesk-sorayomi" do
  version "0.6.0"
  sha256 "82df6ab6b430e7d481975cbdefbd41066f8a85b533b88babed4679b413957ee2"

  url "https:github.comSuwayomiTachidesk-Sorayomireleasesdownload#{version}tachidesk-sorayomi-#{version}-macos-x64.zip"
  name "Tachidesk Sorayomi"
  desc "Manga reader"
  homepage "https:github.comSuwayomiTachidesk-Sorayomi"

  depends_on macos: ">= :catalina"

  app "Sorayomi.app"

  zap trash: [
    "~LibraryApplication Scriptscom.suwayomi.tachideskSorayomi",
    "~LibraryContainerscom.suwayomi.tachideskSorayomi",
  ]
end