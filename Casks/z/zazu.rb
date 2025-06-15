cask "zazu" do
  version "0.6.0"
  sha256 "a726bd20d64d6f03b3251d7841f94fae0f50103533706e9291233aa3adbecf92"

  url "https:github.comtinytacoteamzazureleasesdownloadv#{version}Zazu-#{version}.dmg",
      verified: "github.com"
  name "Zazu"
  desc "Extensible and open-source launcher for hackers, creators and dabblers"
  homepage "https:zazuapp.org"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  app "Zazu.app"

  zap trash: [
    "~LibraryApplication SupportZazu",
    "~LibraryCachesZazu",
    "~LibraryPreferencescom.tinytacoteam.zazu.helper.plist",
    "~LibraryPreferencescom.tinytacoteam.zazu.plist",
  ]
end