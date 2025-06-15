cask "textadept" do
  version "12.7"
  sha256 "20e310e3c7fafcee04db1f252c9fc4ffe23fecc9dbdb2a94ff520ba0ff5b5256"

  url "https:github.comorbitalquarktextadeptreleasesdownloadtextadept_#{version}textadept_#{version}.macOS.zip",
      verified: "github.comorbitalquarktextadept"
  name "Textadept"
  desc "Text editor"
  homepage "https:orbitalquark.github.iotextadept"

  livecheck do
    url :url
    regex(^textadept[._-]v?(\d+(?:\.\d+)+)$i)
  end

  no_autobump! because: :requires_manual_review

  app "Textadept.app"
  binary "ta"

  zap trash: [
    "~.textadept",
    "~LibrarySaved Application Statecom.textadept.savedState",
  ]

  caveats do
    requires_rosetta
  end
end