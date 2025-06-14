cask "brewlet" do
  version "1.7.4"
  sha256 "dca876a90ae80ac02dd53ccdf55322fbcac8022486c65948de10f833af1c7e6a"

  url "https:github.comzkokajaBrewletreleasesdownloadv#{version}Brewlet.zip"
  name "Brewlet"
  desc "Missing menulet for Homebrew"
  homepage "https:github.comzkokajaBrewlet"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :mojave"

  app "Brewlet.app"

  zap trash: "~LibraryPreferenceszzada.Brewlet.plist"
end