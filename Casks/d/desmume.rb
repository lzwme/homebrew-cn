cask "desmume" do
  version "0.9.13"
  sha256 "d42e4bbf8f96b6bfdb3c8be6cf469b606a3b105352460636b1051b8dd0365ebc"

  url "https:github.comTASEmulatorsdesmumereleasesdownloadrelease_#{version.tr(".", "_")}desmume-#{version}-macOS.dmg",
      verified: "github.comTASEmulatorsdesmume"
  name "DeSmuME"
  desc "Nintendo DS emulator"
  homepage "https:desmume.org"

  livecheck do
    url :url
    regex(^(?:release[._-])?(\d+(?:[._-]\d+)+[a-z]?)$i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| match[0].tr("_", ".") }
    end
  end

  no_autobump! because: :requires_manual_review

  app "DeSmuME.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsorg.desmume.desmume.sfl*",
    "~LibraryApplication SupportDeSmuME",
    "~LibraryPreferencesorg.desmume.DeSmuME.plist",
    "~LibrarySaved Application Stateorg.desmume.DeSmuME.savedState",
  ]
end