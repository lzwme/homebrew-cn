cask "fuwari" do
  version "1.0.0"
  sha256 "a294c82b3ec288b2adf828c42bdfa42144efed9aae5c66e03d0708ff9ba71acb"

  url "https:github.comkentya6Fuwarireleasesdownloadv#{version}Fuwari.v#{version}.zip",
      verified: "github.comkentya6Fuwari"
  name "Fuwari"
  desc "Floating screenshot like a sticky"
  homepage "https:fuwari-app.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :high_sierra"

  app "Fuwari v#{version}Fuwari.app"

  uninstall quit: "com.appknop.Fuwari"

  zap trash: [
    "~LibraryApplication Supportcom.appknop.Fuwari",
    "~LibraryCachescom.appknop.Fuwari",
    "~LibraryCachescom.crashlytics.datacom.appknop.Fuwari",
    "~LibraryCachesio.fabric.sdk.mac.datacom.appknop.Fuwari",
    "~LibraryPreferencescom.appknop.Fuwari.plist",
  ]
end