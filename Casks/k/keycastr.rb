cask "keycastr" do
  version "0.10.0"
  sha256 "a3f1cac833addf829869c6336ff1e7d6a665a0294b9bcb04d4f5c46f7e4b0419"

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