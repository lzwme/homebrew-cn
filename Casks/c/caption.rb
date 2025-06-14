cask "caption" do
  version "2.0.1"
  sha256 "bc3c2383ca3be4fb64adc5c8d97af2e372c163272132527db0b4ee5ab6a43605"

  url "https:github.comgielcobbencaptionreleasesdownloadv#{version}caption-#{version}-mac.zip",
      verified: "github.comgielcobbencaption"
  name "Caption"
  desc "Finds and sets up subtitles automatically"
  homepage "https:getcaption.co"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-07-09", because: :unmaintained

  app "Caption.app"

  zap trash: [
    "~LibraryApplication SupportCaption",
    "~LibraryPreferencescom.electron.caption.helper.plist",
    "~LibraryPreferencescom.electron.caption.plist",
    "~LibrarySaved Application Statecom.electron.caption.savedState",
  ]

  caveats do
    requires_rosetta
  end
end