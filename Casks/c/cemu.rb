cask "cemu" do
  version "1.3"
  sha256 "db28a0497ea944a6118f869b50268d5f8c3730c37367033eeebc7cdec08fd60c"

  url "https:github.comCE-ProgrammingCEmureleasesdownloadv#{version}macOS_CEmu.dmg",
      verified: "github.comCE-ProgrammingCEmu"
  name "CEmu"
  homepage "https:ce-programming.github.ioCEmu"

  depends_on macos: ">= :sierra"

  app "CEmu.app"
end