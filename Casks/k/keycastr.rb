cask "keycastr" do
  version "0.9.17"
  sha256 "3f6b657418800d5f96c206463856022205c040f43add09977433814573a060f7"

  url "https:github.comkeycastrkeycastrreleasesdownloadv#{version}KeyCastr.app.zip"
  name "KeyCastr"
  desc "Open-source keystroke visualiser"
  homepage "https:github.comkeycastrkeycastr"

  app "KeyCastr.app"

  zap trash: "~LibraryPreferencesio.github.keycastr.plist"
end