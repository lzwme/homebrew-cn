cask "dozer" do
  version "4.0.0"
  sha256 "d8d37a114c9dab2f16a56e60d8a977115ba34fe408ff7947d0d74028f1f22843"

  url "https:github.comMortennnDozerreleasesdownloadv#{version}Dozer.#{version}.dmg"
  name "Dozer"
  desc "Tool to hide status bar icons"
  homepage "https:github.comMortennnDozer"

  no_autobump! because: :requires_manual_review

  # upstream discussion, https:github.comMortennnDozerissues178
  disable! date: "2024-12-01", because: :discontinued

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "Dozer.app"

  zap trash: [
    "~LibraryApplication Supportcom.mortennn.Dozer",
    "~LibraryPreferencescom.mortennn.Dozer.plist",
  ]
end