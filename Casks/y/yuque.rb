cask "yuque" do
  version "4.0.5.1309,BJe833739b4f8f477fbd930ac4a3acbfed"
  sha256 "40cc46c385debed7dca51a50723f3f9e861737e4baf6ab8fc286247dff0eebbf"

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