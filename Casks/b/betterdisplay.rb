cask "betterdisplay" do
  on_big_sur :or_older do
    version "1.4.15"
    sha256 "26a75c3a4e95b076dcb7468e6ce9f9493675e4a9676fd267e5b32459db900077"

    livecheck do
      skip "Legacy version"
    end

    depends_on macos: ">= :monterey"
  end
  on_monterey :or_newer do
    version "2.2.5"
    sha256 "f4088c8863fce46d40d0bec1533276e79ac486fd9ce95ad233d826acdae7074e"

    livecheck do
      url :url
      strategy :github_latest
    end
  end

  url "https:github.comwaydabberBetterDisplayreleasesdownloadv#{version}BetterDisplay-v#{version}.dmg",
      verified: "github.comwaydabberBetterDisplay"
  name "BetterDisplay"
  desc "Display management tool"
  homepage "https:betterdisplay.pro"

  auto_updates true

  app "BetterDisplay.app"

  uninstall quit: "pro.betterdisplay.BetterDisplay"

  zap trash: [
    "~LibraryApplication SupportBetterDisplay",
    "~LibraryApplication SupportBetterDummy",
    "~LibraryCachespro.betterdisplay.BetterDisplay",
    "~LibraryHTTPStoragespro.betterdisplay.BetterDisplay",
    "~LibraryHTTPStoragespro.betterdisplay.BetterDisplay.binarycookies",
    "~LibraryPreferencespro.betterdisplay.BetterDisplay.plist",
  ]
end