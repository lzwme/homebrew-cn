cask "neteasemusic" do
  version "3.0.15.2556"
  sha256 "f3bd9171cf7aa535d1b7adb750dcbf43935860b6d1c4e6ff730e166c44de31b3"

  url "https:d1.music.126.netdmusicNeteaseCloudMusic_Music_official_#{version}.dmg",
      verified:   "d1.music.126.net",
      user_agent: :fake
  name "NetEase cloud music"
  name "网易云音乐"
  desc "Music streaming platform"
  homepage "https:music.163.com"

  # The upstream download page (https:music.163.com#download) uses a POST
  # request to fetch download link information but livecheck doesn't support
  # POST requests yet. Additionally, the request parameters are encrypted in a
  # particular way (see https:github.comorgsHomebrewdiscussions5756).
  # That said, the API endpoint appears to work with a simple `GET` request.
  livecheck do
    url "https:music.163.comapiappcustomconfigget"
    regex(NeteaseCloudMusic[._-]Music[._-]official[._-]v?(\d+(?:[._]\d+)+)i)
    strategy :json do |json, regex|
      json.dig("data", "web-new-download", "osx", "downloadUrl")&.[](regex, 1)
    end
  end

  auto_updates true
  depends_on macos: ">= :mojave"

  app "NeteaseMusic.app"

  uninstall quit: "com.netease.163music"

  zap trash: [
    "~LibraryApplication Supportcom.netease.163music",
    "~LibraryCachescom.netease.163music",
    "~LibraryContainerscom.netease.163music",
    "~LibraryCookiescom.netease.163music.binarycookies",
    "~LibraryHTTPStoragescom.netease.163music",
    "~LibraryPreferencescom.netease.163music.plist",
    "~LibrarySaved Application Statecom.netease.163music.savedState",
    "~LibraryWebKitcom.netease.163music",
  ]
end