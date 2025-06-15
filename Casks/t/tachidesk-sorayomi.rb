cask "tachidesk-sorayomi" do
  version "0.6.3"
  sha256 "8642b54621bcb0c5f6aa7fcd1477faa50873dae1e63ba14927f0ec311f5b662e"

  url "https:github.comSuwayomiTachidesk-Sorayomireleasesdownload#{version}tachidesk-sorayomi-#{version}-macos-x64.zip"
  name "Tachidesk Sorayomi"
  desc "Manga reader"
  homepage "https:github.comSuwayomiTachidesk-Sorayomi"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :catalina"

  app "Sorayomi.app"

  zap trash: [
    "~LibraryApplication Scriptscom.suwayomi.tachideskSorayomi",
    "~LibraryContainerscom.suwayomi.tachideskSorayomi",
  ]
end