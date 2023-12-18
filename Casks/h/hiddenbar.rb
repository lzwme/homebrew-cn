cask "hiddenbar" do
  version "1.9"
  sha256 "3f54b024f5c1c40bc18aebe39014710289b47e147e71561fae22a661cab26d02"

  url "https:github.comdwarvesfhiddenreleasesdownloadv#{version}Hidden.Bar.#{version}.dmg"
  name "Hidden Bar"
  desc "Utility to hide menu bar items"
  homepage "https:github.comdwarvesfhidden"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :high_sierra"

  app "Hidden Bar.app"

  uninstall quit:      "com.dwarvesv.minimalbar",
            launchctl: "com.dwarvesv.LauncherApplication"

  zap trash: [
    "~LibraryApplication Scriptscom.dwarvesv.LauncherApplication",
    "~LibraryApplication Scriptscom.dwarvesv.minimalbar",
    "~LibraryContainerscom.dwarvesv.LauncherApplication",
    "~LibraryContainerscom.dwarvesv.minimalbar",
  ]
end