cask "nrlquaker-winbox" do
  version "3.41.0"
  sha256 "7fda44219199bf30cff987fe4d3a7508c223c3054afa967500ed59d1ca142f06"

  url "https:github.comnrlquakerwinbox-macreleasesdownloadv#{version}Winbox-mac-#{version}.zip"
  name "Winbox-mac"
  desc "MikroTik Winbox"
  homepage "https:github.comnrlquakerwinbox-mac"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: "<= :sonoma"

  app "Winbox-mac.app"

  zap trash: "~LibraryApplication Supportcom.mikrotik.winbox"
end