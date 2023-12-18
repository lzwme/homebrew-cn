cask "milkman" do
  version "5.7.1"
  sha256 "484ce039a0b71d4b08269edf64f82b0fc645dd1b1269fcb704fd1416ba74a444"

  url "https:github.comwarmuuhmilkmanreleasesdownload#{version}milkman-dist-appbundle-macos64-bin.tgz"
  name "Milkman"
  desc "Extensible request and response workbench"
  homepage "https:github.comwarmuuhmilkman"

  app "Milkman.app"

  zap trash: "~LibraryApplication SupportMilkman"
end