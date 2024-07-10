cask "command-pad" do
  version "0.1.2"
  sha256 "c889b42e9ec648f0b8cfc2cf65b56f5c40fc139486ef236eaa73b29fcc47db6a"

  url "https:github.comsupnatecommand-padreleasesdownloadv#{version}Command.Pad-#{version}.dmg"
  name "Command Pad"
  desc "Start and stop command-line tools and monitor the output"
  homepage "https:github.comsupnatecommand-pad"

  app "Command Pad.app"

  zap trash: [
    "~LibraryApplication SupportCommand Pad",
    "~LibraryLogsCommand Pad",
    "~LibraryPreferencescom.webows.commandpad.helper.plist",
    "~LibraryPreferencescom.webows.commandpad.plist",
    "~LibrarySaved Application Statecom.webowscommandpad.savedState",
  ]

  caveats do
    requires_rosetta
  end
end