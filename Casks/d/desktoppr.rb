cask "desktoppr" do
  version "0.4"
  sha256 "d4da2ee76007c89ba416930c674b30c77adefba7627b4fc643d3856c93d619ee"

  url "https:github.comscriptingosxdesktopprreleasesdownloadv#{version}desktoppr-#{version}.pkg"
  name "desktoppr"
  desc "Command-line tool to set the desktop picture"
  homepage "https:github.comscriptingosxdesktoppr"

  livecheck do
    url :url
    strategy :github_latest
  end

  pkg "desktoppr-#{version}.pkg"

  uninstall pkgutil: "com.scriptingosx.desktoppr"
end