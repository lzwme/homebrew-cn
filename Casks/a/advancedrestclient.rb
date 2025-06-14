cask "advancedrestclient" do
  version "17.0.9"
  sha256 "817d54ee18e970fce4b16ead1422069e3c1f69c5f0edec73e01bc0fd3a210034"

  url "https:github.comadvanced-rest-clientarc-electronreleasesdownloadv#{version}arc-macos.dmg"
  name "Advanced REST Client"
  desc "API testing tool"
  homepage "https:github.comadvanced-rest-clientarc-electron"

  livecheck do
    url :url
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  no_autobump! because: :requires_manual_review

  app "AdvancedRestClient.app"

  zap trash: [
    "~LibraryApplication Supportadvanced-rest-client",
    "~LibraryLogsAdvancedRestClient",
  ]

  caveats do
    requires_rosetta
  end
end