cask "git-credential-manager" do
  arch arm: "arm64", intel: "x64"

  version "2.5.1"
  sha256 arm:   "7177ff729e77ae2b912f24e339b2cad2d315e89d03066850e001027cc41158b3",
         intel: "74d66a7d58556243f8ce640e7b5c5dc82f491435d09dd48f3c35f0e72aa450a0"

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