cask "base" do
  version "2.5.2"
  sha256 "84848093681459b039572a15a82e1cc60e4366ccf5fb69a4de5c90d240871d8c"

  url "https://files.menial.co.uk/base/base_#{version}.zip"
  name "Menial Base"
  desc "App to create, design, edit and browse SQLite 3 database files"
  homepage "https://menial.co.uk/base/"

  livecheck do
    url "https://update.menial.co.uk/software/base/"
    strategy :sparkle, &:short_version
  end

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :mojave"

  app "Base.app"

  zap trash: [
    "~/Library/Application Support/Base",
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/uk.co.menial.base.sfl*",
    "~/Library/Caches/com.apple.helpd/Generated/uk.co.menial.base.help*",
    "~/Library/Caches/com.apple.helpd/SDMHelpData/Other/English/HelpSDMIndexFile/uk.co.menial.base.help*",
    "~/Library/Caches/uk.co.menial.Base",
    "~/Library/Preferences/uk.co.menial.Base.plist",
  ]

  caveats do
    requires_rosetta
  end
end