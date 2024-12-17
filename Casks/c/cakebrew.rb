cask "cakebrew" do
  version "1.3"
  sha256 "a83fc72bd0b4dd62b716adfdfccb0fce3a589b3cba16bea7e2d55d829918e300"

  url "https:github.combrunophilipeCakebrewreleasesdownloadv#{version}cakebrew-#{version}-universal.zip"
  name "Cakebrew"
  desc "GUI app for Homebrew"
  homepage "https:github.combrunophilipeCakebrew"

  disable! date: "2024-12-16", because: :discontinued

  auto_updates true

  app "Cakebrew.app"

  zap trash: [
    "~LibraryCachescom.brunophilipe.Cakebrew",
    "~LibraryPreferencescom.brunophilipe.Cakebrew.plist",
    "~LibrarySaved Application Statecom.brunophilipe.Cakebrew.savedState",
  ]
end