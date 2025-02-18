cask "tidgi" do
  arch arm: "arm64", intel: "x64"

  version "0.12.0-fix"
  sha256 arm:   "ea93da7079d78518430b465f8074ee8ab1625db67ec7db8757abef5be206b847",
         intel: "62a897f56285044da3ea0d0089dd7d446219355b41b60f7b14ed1ba9606b33f3"

  url "https:github.comtiddly-gittlyTidGi-Desktopreleasesdownloadv#{version}TidGi-darwin-#{arch}-#{version.split("-").first}.zip"
  name "TidGi"
  desc "Personal knowledge-base app"
  homepage "https:github.comtiddly-gittlyTidGi-Desktop"

  livecheck do
    url :url
    regex(^\D*?(\d+(?:\.\d+)+.*)$i)
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"

  app "TidGi.app"

  zap trash: [
    "~LibraryApplication SupportTidGi",
    "~LibraryCachescom.tidgi.app",
    "~LibraryCachescom.tidgi.app.ShipIt",
    "~LibraryPreferencescom.tidgi.app.plist",
    "~LibraryPreferencescom.tidgi.plist",
    "~LibrarySaved Application Statecom.microsoft.VSCode.savedState",
  ]
end