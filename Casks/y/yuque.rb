cask "yuque" do
  version "3.4.5.1213,BJ9fec021fee4c44d3b96fa62a5a82bc5d"
  sha256 "b664667b5d8a800fe22fdc4629efea556eea1131bc2d1023c0c452fb219da2c7"

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

  app "语雀.app"

  zap trash: [
    "~LibraryApplication Supportyuque-desktop",
    "~LibraryPreferencescom.yuque.app.plist",
    "~LibrarySaved Application Statecom.yuque.app.savedState",
  ]
end