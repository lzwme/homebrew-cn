cask "yuque" do
  version "3.3.1.1115,BJcccbb9dd184c428dbebef33bb782f5d5"
  sha256 "a02a4b75fd90905e5eaa141d87b63d39456c499a7614512b74f4a81ff11c04a1"

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