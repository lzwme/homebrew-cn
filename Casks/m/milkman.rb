cask "milkman" do
  version "5.9.0"
  sha256 "46cc3a7b763c9b7ba6edae7f901c9ba948a020702c2d976109849bae1cc0cf0c"

  url "https:github.comwarmuuhmilkmanreleasesdownload#{version}milkman-dist-appbundle-macos64-bin.tgz"
  name "Milkman"
  desc "Extensible request and response workbench"
  homepage "https:github.comwarmuuhmilkman"

  app "Milkman.app"

  zap trash: "~LibraryApplication SupportMilkman"
end