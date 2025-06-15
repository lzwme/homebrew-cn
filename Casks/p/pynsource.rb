cask "pynsource" do
  version "1.84"
  sha256 "6c979c404c388bd712c3507d1f9494a11586106179deaba5a2ea83207716a112"

  url "https:github.comabulkapynsourcereleasesdownloadversion-#{version}pynsource-macos-version-#{version}.zip",
      verified: "github.comabulkapynsource"
  name "Pynsource"
  desc "Reverse engineer Python source code into UML"
  homepage "https:www.pynsource.com"

  livecheck do
    url :url
    regex(^version[._-]v?(\d+(?:\.\d+)+)$i)
  end

  no_autobump! because: :requires_manual_review

  app "Pynsource.app"

  zap trash: [
    "~LibraryApplication SupportPyNsource",
    "~LibraryLogspynsource",
    "~LibraryPreferencesPyNSource",
    "~LibrarySaved Application StatePynsource.savedState",
  ]

  caveats do
    requires_rosetta
  end
end