cask "yuque" do
  version "4.1.6.1319,BJ01202048963f4117a817081cc1ba01ed"
  sha256 "5179fcb522d343c14fd124d2acf12d9238179f3e569c4fed9ce7290f6e027ef0"

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
    regex(%2F([a-z0-9]+)%2FYuque[._-]v?(\d+(?:\.\d+)+)\.dmgi)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| "#{match[1]},#{match[0]}" }
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