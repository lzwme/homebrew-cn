cask "bibdesk" do
  version "1.9.7"
  sha256 "89966f14d9b3eebf2a530739ab909bfc61071428d43c628aeae9fdf648a7bec1"

  url "https://downloads.sourceforge.net/bibdesk/BibDesk/BibDesk-#{version.csv.first}/BibDesk-#{version.csv.first}.dmg",
      verified: "downloads.sourceforge.net/bibdesk/"
  name "BibDesk"
  desc "Edit and manage bibliographies"
  homepage "https://bibdesk.sourceforge.io/"

  livecheck do
    url "https://bibdesk.sourceforge.io/bibdesk.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "BibDesk.app"

  zap trash: [
    "~/Library/Application Support/BibDesk",
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/edu.ucsd.cs.mmccrack.bibdesk.sfl*",
    "~/Library/Caches/com.apple.helpd/SDMHelpData/Other/English/HelpSDMIndexFile/edu.ucsd.cs.mmccrack.bibdesk.help*",
    "~/Library/Caches/edu.ucsd.cs.mmccrack.bibdesk",
    "~/Library/Cookies/edu.ucsd.cs.mmccrack.bibdesk.binarycookies",
    "~/Library/Preferences/edu.ucsd.cs.mmccrack.bibdesk.plist",
  ]
end