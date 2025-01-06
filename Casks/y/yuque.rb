cask "yuque" do
  version "3.4.7.1215,BJfb0c68b3aac848b1a9eedba51bb7bf85"
  sha256 "c147e215d8399d06a1d05e4d4708063444da1b624705fc99d48ad578ae026a07"

  url "https:app.nlark.comyuque-desktop#{version.csv.first}#{version.csv.second}Yuque-#{version.csv.first}.dmg",
      verified: "app.nlark.comyuque-desktop"
  name "Yuque"
  name "语雀"
  desc "Cloud knowledge base"
  homepage "https:www.yuque.com"

  # The version on the download page is the stable version (see:
  # https:github.comHomebrewhomebrew-caskpull111472)
  livecheck do
    url "https:www.yuque.comdownload"
    regex(yuque-desktop%2Fv?(\d+(?:\.\d+)+)%2F([a-z0-9]+).*?\.dmgi)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| "#{match[0]},#{match[1]}" }
    end
  end

  depends_on macos: ">= :high_sierra"

  app "语雀.app"

  zap trash: [
    "~LibraryApplication Supportyuque-desktop",
    "~LibraryPreferencescom.yuque.app.plist",
    "~LibrarySaved Application Statecom.yuque.app.savedState",
  ]
end