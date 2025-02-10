cask "tachidesk-sorayomi" do
  version "0.6.1"
  sha256 "3405d65fb23517e28e87bfb16817e5d439fb8d789b0fea9428e9c3caa1116aa5"

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