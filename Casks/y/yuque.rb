cask "yuque" do
  version "3.2.3.1111,BJb5bf4507bf4f47c8b99646f224713568"
  sha256 "096ba87a12e9f130da46f4b63554bc5b6696d3896b84168bcc09eb58220e3ce9"

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