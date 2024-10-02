cask "keyclu" do
  version "0.28"
  sha256 "b18a04ab4d4dec6c0ea87e6536440ff4462638dd39b5e4c488c948a17e0d74df"

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