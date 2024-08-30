cask "keycastr" do
  version "0.10.1"
  sha256 "11afd0b5888cec9d867394fc33e5a2cd206b826849f8d5b87ab9f6039f209549"

  url "https:github.comkeycastrkeycastrreleasesdownloadv#{version}KeyCastr.app.zip"
  name "KeyCastr"
  desc "Open-source keystroke visualiser"
  homepage "https:github.comkeycastrkeycastr"

  auto_updates true

  app "KeyCastr.app"

  zap trash: [
    "~LibraryHTTPStoragesio.github.keycastr",
    "~LibraryPreferencesio.github.keycastr.plist",
  ]
end