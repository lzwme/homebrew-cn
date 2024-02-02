cask "gpgfrontend" do
  version "2.1.2"

  on_big_sur do
    sha256 "46b285779f9674438df79a660c76a8baafa9aa25c788f20f6200d652cb1e78ff"

    url "https:github.comsaturnericGpgFrontendreleasesdownloadv#{version}GpgFrontend-#{version}-macos-11.dmg",
        verified: "github.comsaturnericGpgFrontend"
  end
  on_monterey :or_newer do
    sha256 "d9ad042487a56800e44aff7111f03a0757ef1580c771ed99627cab988196cb67"

    url "https:github.comsaturnericGpgFrontendreleasesdownloadv#{version}GpgFrontend-#{version}-macos-12.dmg",
        verified: "github.comsaturnericGpgFrontend"
  end

  name "GpgFrontend"
  desc "OpenPGPGnuPG crypto, sign and key management tool"
  homepage "https:gpgfrontend.bktus.com"

  depends_on macos: ">= :big_sur"
  depends_on formula: "gnupg"

  app "GpgFrontend.app"

  zap trash: [
    "~LibraryApplication Scriptspub.gpgfrontend.gpgfrontend",
    "~LibraryApplication SupportGpgFrontend",
    "~LibraryContainerspub.gpgfrontend.gpgfrontend",
    "~LibraryPreferencesGpgFrontend",
    "~LibraryPreferencesGpgFrontend.plist",
    "~LibraryPreferencespub.gpgfrontend.gpgfrontend.plist",
    "~LibrarySaved Application Statepub.gpgfrontend.gpgfrontend.savedState",
  ]
end