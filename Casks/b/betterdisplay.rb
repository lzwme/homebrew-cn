cask "betterdisplay" do
  on_big_sur :or_older do
    version "1.4.15"
    sha256 "26a75c3a4e95b076dcb7468e6ce9f9493675e4a9676fd267e5b32459db900077"

    livecheck do
      skip "Legacy version"
    end
  end
  on_monterey do
    version "2.3.9"
    sha256 "3ee043fd5893ab354efbc4c9a92295a21b365e55af34cc64612255878b746722"

    livecheck do
      skip "Legacy version"
    end
  end
  on_ventura :or_newer do
    version "3.5.5"
    sha256 "274613d7f15a46ab2878e281b4203cb473c39d272de99febfd49bffcd9a5b2f2"

    livecheck do
      url "https:betterdisplay.probetterdisplaysparkleappcast.xml"
      strategy :sparkle do |items|
        items.find { |item| item.channel.nil? }&.short_version
      end
    end
  end

  url "https:github.comwaydabberBetterDisplayreleasesdownloadv#{version}BetterDisplay-v#{version}.dmg",
      verified: "github.comwaydabberBetterDisplay"
  name "BetterDisplay"
  desc "Display management tool"
  homepage "https:betterdisplay.pro"

  auto_updates true
  depends_on macos: ">= :mojave"

  app "BetterDisplay.app"

  uninstall quit:       "pro.betterdisplay.BetterDisplay",
            login_item: "BetterDisplay"

  zap trash: [
    "~LibraryApplication SupportBetterDisplay",
    "~LibraryApplication SupportBetterDummy",
    "~LibraryCachespro.betterdisplay.BetterDisplay",
    "~LibraryCachesSentryCrashBetterDisplay",
    "~LibraryHTTPStoragespro.betterdisplay.BetterDisplay",
    "~LibraryHTTPStoragespro.betterdisplay.BetterDisplay.binarycookies",
    "~LibraryPreferencespro.betterdisplay.BetterDisplay.plist",
  ]
end