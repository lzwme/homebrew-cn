cask "yuque" do
  version "3.4.0.1204,BJ5fbf5b1c7ce347449e93fd1cadb52e1d"
  sha256 "06be01615250aaf46aabcba8df7f570af21601dc33d85864d6c7356e9a00b6dc"

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