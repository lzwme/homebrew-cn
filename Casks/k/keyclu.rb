cask "keyclu" do
  version "0.29"
  sha256 "75333dc1a8002c55276a3902fc3465c920f58ebad788f34f991231433e874749"

  url "https:github.comAnzeKeyCluCaskreleasesdownloadv#{version}KeyClu.zip",
      verified: "github.comAnzeKeyCluCask"
  name "KeyClu"
  desc "Find shortcuts for any installed application"
  homepage "https:sergii.tatarenkov.namekeyclusupport"

  livecheck do
    url "https:sergii.tatarenkov.namekeycluappcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "KeyClu.app"

  uninstall quit: "com.0804Team.KeyClu"

  zap trash: [
    "~LibraryCachescom.0804Team.KeyClu",
    "~LibraryContainerscom.0804Team.KeyClu",
    "~LibraryGroup Containersgroup.com.0804Team.KeyClu",
    "~LibraryHTTPStoragescom.0804Team.KeyClu",
    "~LibraryPreferencescom.0804Team.KeyClu.plist",
    "~LibrarySaved Application Statecom.0804Team.KeyClu.savedState",
  ]
end