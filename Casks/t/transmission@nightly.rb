cask "transmission@nightly" do
  version "9767,200af70762"
  sha256 "5dedc03692bcb0216d44670fb48eb8cddba83853522a4a7bdc0242a463132657"

  url "https://build.transmissionbt.com/job/trunk-mac/#{version.csv.first}/artifact/release/Transmission-#{version.csv.second}.dmg"
  name "Transmission"
  desc "Open-source BitTorrent client"
  homepage "https://transmissionbt.com/"

  livecheck do
    url "https://build.transmissionbt.com/job/trunk-mac/lastSuccessfulBuild/artifact/release/"
    regex(/>\s*\#(\d+)\s*<.+?href=.*?Transmission[._-](\h+)\.dmg/im)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| "#{match[0]},#{match[1]}" }
    end
  end

  conflicts_with cask: "transmission"
  depends_on macos: ">= :big_sur"

  app "Transmission.app"

  zap trash: [
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/org.m0k.transmission.sfl*",
    "~/Library/Application Support/Transmission",
    "~/Library/Caches/com.apple.helpd/SDMHelpData/Other/English/HelpSDMIndexFile/org.m0k.transmission.help",
    "~/Library/Caches/com.apple.helpd/SDMHelpData/Other/English/HelpSDMIndexFile/Transmission Help*",
    "~/Library/Caches/org.m0k.transmission",
    "~/Library/Cookies/org.m0k.transmission.binarycookies",
    "~/Library/Preferences/org.m0k.transmission.LSSharedFileList.plist",
    "~/Library/Preferences/org.m0k.transmission.plist",
    "~/Library/Saved Application State/org.m0k.transmission.savedState",
  ]
end