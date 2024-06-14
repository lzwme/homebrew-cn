cask "jandi-statusbar" do
  version "1.14"
  sha256 "78467d64d142694bc8ac6f896ff51b74e8480f974ec448ddcd8e8e09f5040578"

  url "https:github.comtechinparkJandireleasesdownloadv#{version}jandi.dmg"
  name "jandi"
  desc "GitHub contributions in your status bar"
  homepage "https:github.comtechinparkJandi"

  livecheck do
    skip "No reliable way to get version info"
  end

  app "jandi.app"

  zap trash: [
    "~LibraryCachescom.tmsae.jandi",
    "~LibraryPreferencescom.tmsae.jandi.plist",
  ]
end