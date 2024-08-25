cask "keycastr" do
  version "0.9.18"
  sha256 "ab5d9cfd6d321a854bfb0c7e4ff81a7afc763f45f072fd1ad0532fedb29f5271"

  url "https:github.comkeycastrkeycastrreleasesdownloadv#{version}KeyCastr.app.zip"
  name "KeyCastr"
  desc "Open-source keystroke visualiser"
  homepage "https:github.comkeycastrkeycastr"

  app "KeyCastr.app"

  zap trash: [
    "~LibraryHTTPStoragesio.github.keycastr",
    "~LibraryPreferencesio.github.keycastr.plist",
  ]
end