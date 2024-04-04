cask "yuque" do
  version "3.4.1.1206,BJ771c3d4a5cbb41fa818af20f384cf7ea"
  sha256 "af74f6b300b548c60a03e49e45d1127ac793781d6429acbbaefc175b75cecdec"

  url "https:app.nlark.comyuque-desktop#{version.csv.first}#{version.csv.second}Yuque-#{version.csv.first}.dmg",
      verified: "app.nlark.comyuque-desktop"
  name "Yuque"
  name "语雀"
  desc "Cloud knowledge base"
  homepage "https:www.yuque.com"

  # The stable version is that listed on the download page. See:
  #   https:github.comHomebrewhomebrew-caskpull111472
  livecheck do
    url "https:www.yuque.comdownload"
    regex(yuque-desktop%2F(\d+(?:\.\d+)+)%2F([A-Za-z0-9]+).*?\.dmgi)
    strategy :page_match do |page, regex|
      page.scan(regex).map do |match|
        "#{match[0]},#{match[1]}"
      end
    end
  end

  app "语雀.app"

  zap trash: [
    "~LibraryApplication Supportyuque-desktop",
    "~LibraryPreferencescom.yuque.app.plist",
    "~LibrarySaved Application Statecom.yuque.app.savedState",
  ]
end