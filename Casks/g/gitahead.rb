cask "gitahead" do
  version "2.7.1"
  sha256 "32c17d345fedc869efd37080d0905aa1a85d8d5ba5a4509058fdd35f224f2a04"

  url "https://ghfast.top/https://github.com/gitahead/gitahead/releases/download/v#{version}/GitAhead-#{version}.dmg"
  name "GitAhead"
  desc "Git Client"
  homepage "https://github.com/gitahead/gitahead"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :big_sur"

  app "GitAhead.app"

  zap trash: [
    "~/Library/Application Support/GitAhead",
    "~/Library/Preferences/com.gitahead.GitAhead.plist",
    "~/Library/Saved Application State/com.gitahead.GitAhead.savedState",
  ]
end