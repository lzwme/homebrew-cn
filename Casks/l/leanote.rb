cask "leanote" do
  version "2.7.0"
  sha256 "18c680dc9f3af54a0ef4edfa987407ed41bbd4654bc1791720cb40e0047b3da4"

  url "https:github.comleanotedesktop-appreleasesdownloadv#{version}leanote-desktop-mac-v#{version}.zip",
      verified: "github.comleanotedesktop-app"
  name "Leanote"
  homepage "http:leanote.org"

  app "Leanote.app"
end