cask "keycastr" do
  version "0.10.3"
  sha256 "e3384bb08686d2b2bba509d0d119a1c2b714046b5407871adfc1a51574298a25"

  url "https:github.comkeycastrkeycastrreleasesdownloadv#{version}KeyCastr.app.zip"
  name "KeyCastr"
  desc "Open-source keystroke visualiser"
  homepage "https:github.comkeycastrkeycastr"

  livecheck do
    url "https:keycastr.github.ioappcast.xml"
    strategy :sparkle
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "KeyCastr.app"

  zap trash: [
    "~LibraryHTTPStoragesio.github.keycastr",
    "~LibraryPreferencesio.github.keycastr.plist",
  ]
end