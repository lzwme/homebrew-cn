cask "qtox" do
  version "1.17.6"
  sha256 "f321fad4b5cb5f77ed14f1c4e08790c9acff6113ccf9e18327d463411c24d32e"

  url "https:github.comqToxqToxreleasesdownloadv#{version}qTox.dmg",
      verified: "github.comqToxqTox"
  name "qTox"
  desc "Instant messaging and video conferencing app"
  homepage "https:qtox.github.io"

  deprecate! date: "2024-02-13", because: :discontinued

  app "qTox.app"

  zap trash: [
    "~LibraryPreferenceschat.tox.qtox.plist",
    "~LibrarySaved Application Statechat.tox.qtox.savedState",
  ]

  caveats do
    requires_rosetta
  end
end