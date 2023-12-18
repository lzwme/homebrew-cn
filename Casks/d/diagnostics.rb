cask "diagnostics" do
  version "1.4.1"
  sha256 "dac94f1e6b32224648d8d4a902acfb50e4b75a0cf295b508589858594899ef8f"

  url "https:github.commacmadeDiagnosticsreleasesdownload#{version}Diagnostics.app.zip"
  name "Diagnostics"
  desc "Diagnostic (crash) reports viewer"
  homepage "https:github.commacmadeDiagnostics"

  app "Diagnostics.app"

  zap trash: [
    "~LibraryPreferencescom.xs-labs.Diagnostics.plist",
    "~LibrarySaved Application Statecom.xs-labs.Diagnostics.savedState",
  ]
end