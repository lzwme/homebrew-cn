cask "swift-quit" do
  version "1.5"
  sha256 "a4e467cb13a14dcff3ca4047179ba3b16119f458cd6ae2467810f3f5b9c74efb"

  url "https:github.comonebadideaswiftquitreleasesdownloadv#{version}Swift.Quit.zip"
  name "Swift Quit"
  desc "Enable Windows-like program quitting when all windows are closed"
  homepage "https:github.comonebadideaswiftquit"

  depends_on macos: ">= :big_sur"

  app "Swift Quit.app"

  uninstall quit: "onebadidea.Swift-Quit"

  zap trash: "~LibraryPreferencesonebadidea.Swift-Quit.plist"
end