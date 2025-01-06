cask "react-native-debugger" do
  version "0.14.0"
  sha256 "3be2e2b0d0fdac91f77905bbdcb835316ef8995aec1de91f55838cf0a8da6625"

  url "https:github.comjhen0409react-native-debuggerreleasesdownloadv#{version}rn-debugger-macos-universal.zip"
  name "React Native Debugger"
  desc "Standalone app for debugging React Native apps"
  homepage "https:github.comjhen0409react-native-debugger"

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "React Native Debugger.app"

  zap trash: [
    "~LibraryPreferencescom.electron.react-native-debugger.plist",
    "~LibrarySaved Application Statecom.electron.react-native-debugger.savedState",
  ]
end