cask "ariang" do
  version "1.3.8"
  sha256 "1a441eda861a34d4b8ae52604ee28a1ff8c5741b24b79ee7300b7b8471ad2ed9"

  url "https:github.commayswindAriaNg-Nativereleasesdownload#{version}AriaNg_Native-#{version}-macOS-x64.dmg"
  name "AriaNg Native"
  desc "Better aria2 desktop frontend than AriaNg"
  homepage "https:github.commayswindAriaNg-Native"

  depends_on macos: ">= :high_sierra"

  app "AriaNg Native.app"

  zap trash: [
    "~LibraryPreferencesnet.mayswind.ariang.plist",
    "~LibrarySaved Application Statenet.mayswind.ariang.savedState",
  ]

  caveats do
    requires_rosetta
  end
end