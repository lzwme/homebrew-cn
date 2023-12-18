cask "doll" do
  version "0.0.9.1"
  sha256 "b4de2bef0438a7e9cf76af8beaa797012bbef5cf0d51a44c7c3c8227c2ee63a3"

  url "https:github.comxiaogdgenuineDollreleasesdownloadv#{version}Doll.#{version}.dmg"
  name "Doll"
  desc "Utility to show apps badges from the dock in the menu bar"
  homepage "https:github.comxiaogdgenuineDoll"

  depends_on macos: ">= :big_sur"

  app "Doll.app"

  zap trash: "~LibraryPreferencescom.xiaogd.Doll.plist"
end