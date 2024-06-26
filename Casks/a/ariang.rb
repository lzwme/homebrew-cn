cask "ariang" do
  version "1.3.7"
  sha256 "afd6303adaa5b930ac7351c18aa4ee56ff04e01a741965194ec5daae66997959"

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