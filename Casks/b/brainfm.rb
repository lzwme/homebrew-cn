cask "brainfm" do
  version "0.1.5"
  sha256 "c6869346e1b68aa43db89f785bca6311d1aee117975a0df47c72cf7ab478e7c0"

  url "https:github.comDiniusBrain.fm-Desktop-Clientreleasesdownloadv#{version}brainfm-macos.zip"
  name "Brain.fm"
  desc "Desktop client for brain.fm"
  homepage "https:github.comDiniusBrain.fm-Desktop-Client"

  app "Brain.fm.app"

  zap trash: [
    "~LibraryPreferencescom.electron.brain.fm.helper.plist",
    "~LibraryPreferencescom.electron.brain.fm.plist",
    "~LibrarySaved Application Statecom.electron.brain.fm.savedState",
  ]

  caveats do
    requires_rosetta
  end
end