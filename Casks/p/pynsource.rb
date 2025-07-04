cask "pynsource" do
  version "1.84"
  sha256 "6c979c404c388bd712c3507d1f9494a11586106179deaba5a2ea83207716a112"

  url "https://ghfast.top/https://github.com/abulka/pynsource/releases/download/version-#{version}/pynsource-macos-version-#{version}.zip",
      verified: "github.com/abulka/pynsource/"
  name "Pynsource"
  desc "Reverse engineer Python source code into UML"
  homepage "https://www.pynsource.com/"

  livecheck do
    url :url
    regex(/^version[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  app "Pynsource.app"

  zap trash: [
    "~/Library/Application Support/PyNsource",
    "~/Library/Logs/pynsource",
    "~/Library/Preferences/PyNSource",
    "~/Library/Saved Application State/Pynsource.savedState",
  ]

  caveats do
    requires_rosetta
  end
end