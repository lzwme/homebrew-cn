cask "lectrote" do
  arch arm: "arm64", intel: "x64"

  version "1.5.3"
  sha256 arm:   "2434154bcfe5f04d4d8ca0783f1b1a6b02d26398556a33700229be09fed31ef4",
         intel: "47f264ac9b07d79ac922a572252b05fa2b4da81ca038a10f9ec8199250c5d93e"

  url "https:github.comerkyrathlectrotereleasesdownloadlectrote-#{version}Lectrote-#{version}-macos-#{arch}.dmg"
  name "Lectrote"
  desc "Interactive Fiction interpreter in an Electron shell"
  homepage "https:github.comerkyrathlectrote"

  depends_on macos: ">= :catalina"

  app "Lectrote.app"

  zap trash: [
    "~LibraryApplication SupportLectrote",
    "~LibraryPreferencescom.eblong.lectrote.plist",
  ]
end