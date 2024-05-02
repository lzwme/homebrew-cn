cask "textadept" do
  version "12.4"
  sha256 "b81ffdf7259b2a98c1f02aebf97752724c2f66fafefed0c8bff9135dc99f56b3"

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