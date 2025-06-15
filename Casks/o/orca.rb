cask "orca" do
  version "1.3.1"
  sha256 "79b1b346df9113cd56e545b223a73179801116ca9e009f3c5fe0fac97c0df1ab"

  url "https:github.complotlyorcareleasesdownloadv#{version}mac-release.zip"
  name "Orca"
  desc "Generate images of interactive plotly charts"
  homepage "https:github.complotlyorca"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  container nested: "orca-#{version}.dmg"

  app "orca.app"

  zap trash: [
    "~LibraryApplication Supportorca",
    "~LibraryPreferencescom.plotly.orca.plist",
  ]

  caveats do
    requires_rosetta
  end
end