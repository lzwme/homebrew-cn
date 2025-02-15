cask "ariang" do
  arch arm: "arm64", intel: "x64"

  version "1.3.10"
  sha256 arm:   "431d1b299a17b0285bc6b00d088c512e61f532677820164c4762da997735c723",
         intel: "fa9d7d3f8c4225f6dd63c8909d5bf10246ec1dbb7779009478f2b645ec00e8ee"

  url "https:github.commayswindAriaNg-Nativereleasesdownload#{version}AriaNg_Native-#{version}-macOS-#{arch}.dmg"
  name "AriaNg Native"
  desc "Better aria2 desktop frontend than AriaNg"
  homepage "https:github.commayswindAriaNg-Native"

  depends_on macos: ">= :high_sierra"

  app "AriaNg Native.app"

  zap trash: [
    "~LibraryPreferencesnet.mayswind.ariang.plist",
    "~LibrarySaved Application Statenet.mayswind.ariang.savedState",
  ]
end