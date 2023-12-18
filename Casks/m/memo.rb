cask "memo" do
  version "1.0.3"
  sha256 :no_check

  url "https:usememo.comMemoSetup.dmg"
  name "Memo"
  desc "Note taking app using GitHub Gists"
  homepage "https:usememo.com"

  livecheck do
    url "https:raw.githubusercontent.combtkmemomasterpackage.json"
    strategy :json do |json|
      json["version"]
    end
  end

  app "Memo.app"

  zap trash: [
    "~LibraryApplication SupportMemo",
    "~LibraryPreferencescom.usememo.app.plist",
    "~LibrarySaved Application Statecom.usememo.app.savedState",
  ]
end