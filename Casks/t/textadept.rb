cask "textadept" do
  version "12.2"
  sha256 "67b7c0f811c3190a93a0bd468a864168bfac0b09afb07c8daab306b8123dd8a6"

  url "https:github.comorbitalquarktextadeptreleasesdownloadtextadept_#{version}textadept_#{version}.macOS.zip",
      verified: "github.comorbitalquarktextadept"
  name "Textadept"
  desc "Text editor"
  homepage "https:orbitalquark.github.iotextadept"

  livecheck do
    url :url
    regex(^textadept[._-]v?(\d+(?:\.\d+)+)$i)
  end

  app "Textadept.app"
  binary "ta"

  zap trash: [
    "~.textadept",
    "~LibrarySaved Application Statecom.textadept.savedState",
  ]
end