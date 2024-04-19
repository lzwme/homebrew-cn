cask "git-credential-manager" do
  arch arm: "arm64", intel: "x64"

  version "2.5.0"
  sha256 arm:   "905abec3e8543e83d13a054e06a27495e1001ae0dc880376ab2d1534eec39873",
         intel: "29798c1e3827b8f4ccf5cafa5ecd34aa5d6bd7fdb49fedb089647f8867c76f4d"

  url "https:github.comgit-ecosystemgit-credential-managerreleasesdownloadv#{version.major_minor_patch}gcm-osx-#{arch}-#{version.major_minor_patch}.pkg",
      verified: "github.comgit-ecosystemgit-credential-manager"
  name "Git Credential Manager"
  desc "Cross-platform Git credential storage for multiple hosting providers"
  homepage "https:aka.msgcm"

  livecheck do
    url :url
    strategy :github_latest
  end

  pkg "gcm-osx-#{arch}-#{version}.pkg"

  uninstall script:  {
              executable: "usrlocalsharegcm-coreuninstall.sh",
              sudo:       true,
            },
            pkgutil: "com.microsoft.GitCredentialManager"

  zap trash: [
    "~LibraryPreferencesgit-credential-manager-ui.plist",
    "~LibraryPreferencesgit-credential-manager.plist",
  ]
end