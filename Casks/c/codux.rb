cask "codux" do
  arch arm: "arm64", intel: "x64"

  version "15.18.1"
  sha256 arm:   "c44f4242b9d7757689fb80f91de4d6c66bbb0e631586c901552ae720ff1f312d",
         intel: "2a030d88f4ceb1f8166861e2161b26e035eb4d5b8f6b8408b752274c89569221"

  url "https:github.comwixplosivescodux-versionsreleasesdownload#{version}Codux-#{version}.#{arch}.dmg",
      verified: "github.comwixplosivescodux-versions"
  name "Codux"
  desc "React IDE built to visually edit component styling and layouts"
  homepage "https:www.codux.com"

  livecheck do
    url "https:www.codux.comdownload"
    regex(href=.*?Codux[._-]v?(\d+(?:\.\d+)+)[._-]#{arch}\.dmgi)
  end

  depends_on macos: ">= :catalina"

  app "Codux.app"

  zap trash: [
    "~LibraryApplication SupportCodux",
    "~LibraryPreferencescom.wixc3.wcs.plist",
    "~LibrarySaved Application Statecom.wixc3.wcs.savedState",
  ]
end