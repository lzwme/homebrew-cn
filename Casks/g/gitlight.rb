cask "gitlight" do
  arch arm: "aarch64", intel: "x64"

  version "0.17.5"
  sha256 arm:   "11cf26a907520b734b009b91578240b750c7210f8e498fc742c4eca0b87c5995",
         intel: "fd066caa44b37fd81619ca1e3ed9fb3465b00cfd3bddbb938d88d72162805890"

  url "https:github.comcolinlienardgitlightreleasesdownloadgitlight-v#{version}GitLight_#{version}_#{arch}.dmg",
      verified: "github.comcolinlienardgitlight"
  name "GitLight"
  desc "Desktop notifications for GitHub & GitLab"
  homepage "https:gitlight.app"

  depends_on macos: ">= :high_sierra"

  app "GitLight.app"

  zap trash: [
    "~LibraryApplication Supportapp.gitlight",
    "~LibraryCachesapp.gitlight",
    "~LibraryLaunchAgentsGitLight.plist",
    "~LibraryPreferencesapp.gitlight.plist",
    "~LibrarySaved Application Stateapp.gitlight.savedState",
    "~LibraryWebKitapp.gitlight",
  ]
end