cask "thyme" do
  version "0.5.1"
  sha256 "9757fff3198d379d3fc1d6231669d1eea6e0d1ba7aa2b876782998415d050ae2"

  url "https:github.comjoaomorenothymereleasesdownload#{version}Thyme.#{version}.dmg",
      verified: "github.comjoaomorenothyme"
  name "Thyme"
  desc "Task timer"
  homepage "https:joaomoreno.github.iothyme"

  app "Thyme.app"

  zap trash: [
    "~LibraryApplication SupportThyme",
    "~LibraryPreferencescom.joaomoreno.Thyme.plist",
  ]
end