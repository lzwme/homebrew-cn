cask "middleclick" do
  version "3.0.0"
  sha256 "e80bc000bc8370349c83648307f5443dfa3e7cac3f67faaad589bceebec9fc33"

  url "https:github.comartginzburgMiddleClickreleasesdownload#{version}MiddleClick.zip"
  name "MiddleClick"
  desc "Utility to extend trackpad functionality"
  homepage "https:github.comartginzburgMiddleClick"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :high_sierra"

  app "MiddleClick.app"

  uninstall quit:       "art.ginzburg.MiddleClick",
            login_item: "MiddleClick"

  zap trash: "~LibraryPreferencesart.ginzburg.MiddleClick.plist"
end