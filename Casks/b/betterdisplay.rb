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
    version "2.2.2"
    sha256 "b93f2499844a926aad7e3691111bf3220a29644b52dc8efecb5eb6dcb71610e2"

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