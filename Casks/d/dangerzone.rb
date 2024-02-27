cask "dangerzone" do
  arch arm: "arm64", intel: "i686"

  version "0.6.0"
  sha256 arm:   "334e0baeba59199d513b59ef3cae6d33519a79e7733bc9e3f199d90a25f27d17",
         intel: "839a0727b4fad565e76919cb0c8379adc5d217eed1ed343022abdc1559a9af7b"

  url "https:github.comfreedomofpressdangerzonereleasesdownloadv#{version}Dangerzone-#{version}-#{arch}.dmg",
      verified: "github.comfreedomofpressdangerzone"
  name "Dangerzone"
  desc "Convert potentially dangerous PDFs or Office documents into safe PDFs"
  homepage "https:dangerzone.rocks"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Dangerzone.app"

  zap trash: [
    "~LibraryApplication Supportdangerzone",
    "~LibrarySaved Application Statepress.freedom.dangerzone.savedState",
  ]
end