cask "nuclear" do
  arch arm: "arm64", intel: "x64"

  version "0.6.41"
  sha256 arm:   "2bcc9a959f7bfbe137d4634de5f1e1a294595008da88bb226b6ce34c1aaecead",
         intel: "83756443ad8867cc110d07a650883f64cc8d9449c422302f79e1ec4fddd30e65"

  url "https:github.comnukeopnuclearreleasesdownloadv#{version}nuclear-v#{version}-#{arch}.dmg",
      verified: "github.comnukeopnuclear"
  name "Nuclear"
  desc "Streaming music player"
  homepage "https:nuclear.js.org"

  livecheck do
    url :url
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  app "nuclear.app"

  zap trash: [
    "~LibraryApplication Supportnuclear",
    "~LibraryLogsnuclear",
    "~LibraryPreferencesnuclear.plist",
    "~LibrarySaved Application Statenuclear.savedState",
  ]
end