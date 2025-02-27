cask "tidgi" do
  arch arm: "arm64", intel: "x64"

  version "0.12.1-update"
  sha256 arm:   "fdf70c092ee4d8b4f410b72b14fa6243f58d26dc5a26860e2cb8513874e021d6",
         intel: "5d9adaa2d7fa7b0b2b6f62c16d94d344cad3f81e7634d5ac658fd0c63bbc84dc"

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