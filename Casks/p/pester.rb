cask "pester" do
  version "1.1b24"
  sha256 "1a05282c1de4cde91048bac86a17e39bdf18990be98d43758ce248f67a124e46"

  url "https://sabi.net/nriley/software/Pester-#{version}.dmg"
  name "Pester"
  desc "Set, dismiss or snooze an alarm or timer"
  homepage "https://sabi.net/nriley/software/index.html#pester"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-10-10", because: :unmaintained

  depends_on macos: ">= :sierra"

  app "Pester.app"

  caveats do
    requires_rosetta
  end
end