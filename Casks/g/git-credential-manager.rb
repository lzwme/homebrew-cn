cask "git-credential-manager" do
  arch arm: "arm64", intel: "x64"

  version "2.6.0"
  sha256 arm:   "b373cb79cddc21c113c29db8d1acae7614a99d65cffcf6657401807dcf464f74",
         intel: "a32cb0895ae29aa21e968b0422eacace64f16204098a1fd11189ddf911b19585"

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