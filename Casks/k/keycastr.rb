cask "keycastr" do
  version "0.9.16"
  sha256 "7ca2e35e29e79ae62d348fc4b3c758dab77f65d933b8ed77881fb252d6a61845"

  url "https:github.comkeycastrkeycastrreleasesdownloadv#{version}KeyCastr.app.zip"
  name "KeyCastr"
  desc "Open-source keystroke visualizer"
  homepage "https:github.comkeycastrkeycastr"

  app "KeyCastr.app"

  zap trash: "~LibraryPreferencesio.github.keycastr.plist"
end