cask "jclasslib-bytecode-viewer" do
  version "6.1"
  sha256 "796643da5b04a8baeec377746306c1871628e3d1cdc7203d15deff717676634d"

  url "https:github.comingokegeljclasslibreleasesdownload#{version}jclasslib_macos_#{version.dots_to_underscores}.dmg"
  name "jclasslib bytecode viewer"
  desc "Visualise all aspects of compiled Java class files and the contained bytecode"
  homepage "https:github.comingokegeljclasslib"

  no_autobump! because: :requires_manual_review

  auto_updates true

  app "jclasslib bytecode viewer.app"

  zap trash: "~LibrarySaved Application Statecom.install4j.*"
end