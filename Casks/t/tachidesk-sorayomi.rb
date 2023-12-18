cask "tachidesk-sorayomi" do
  version "0.5.19"
  sha256 "c54fc3975ef6c8798b4a662c8a4b681814a2caaada80021d9294a0ffd3081ebf"

  url "https:github.comSuwayomiTachidesk-Sorayomireleasesdownload#{version}tachidesk-sorayomi-#{version}-macos-x64.zip"
  name "Tachidesk Sorayomi"
  desc "Manga reader"
  homepage "https:github.comSuwayomiTachidesk-Sorayomi"

  depends_on macos: ">= :mojave"

  app "Tachidesk Sorayomi.app"

  zap trash: [
    "~LibraryApplication Scriptscom.suwayomi.tachideskSorayomi",
    "~LibraryContainerscom.suwayomi.tachideskSorayomi",
  ]
end