cask "machoexplorer" do
  version "1.0"
  sha256 "3f9b9e400e008174cb9c4eb8f186b18060c5a12a93622c9d5f60254500735232"

  url "https:github.comeverettjfMachOExplorerreleasesdownloadv#{version}MachOExplorer.dmg"
  name "MachOExplorer"
  desc "Mach-O Executable File Explorer"
  homepage "https:github.comeverettjfMachOExplorer"

  app "MachOExplorer.app"

  caveats do
    discontinued
  end
end