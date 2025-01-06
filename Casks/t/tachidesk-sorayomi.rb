cask "tachidesk-sorayomi" do
  version "0.5.23"
  sha256 "fcbc26b4d79d11aee89ce49169d2037cc1aaeed2133ff0b63b4474c4e5d0bea9"

  url "https:github.comSuwayomiTachidesk-Sorayomireleasesdownload#{version}tachidesk-sorayomi-#{version}-macos-x64.zip"
  name "Tachidesk Sorayomi"
  desc "Manga reader"
  homepage "https:github.comSuwayomiTachidesk-Sorayomi"

  depends_on macos: ">= :catalina"

  app "Tachidesk Sorayomi.app"

  zap trash: [
    "~LibraryApplication Scriptscom.suwayomi.tachideskSorayomi",
    "~LibraryContainerscom.suwayomi.tachideskSorayomi",
  ]
end