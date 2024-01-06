cask "macvim" do
  version "179"
  sha256 "61b16fea605558a4753f225a5b426d1f00322d7e3b2429415287528536610084"

  url "https:github.commacvim-devmacvimreleasesdownloadrelease-#{version}MacVim.dmg"
  name "MacVim"
  desc "Text editor"
  homepage "https:github.commacvim-devmacvim"

  livecheck do
    url :url
    regex(^release[._-]v?(\d+(?:\.\d+)*)$i)
  end

  auto_updates true
  conflicts_with formula: "macvim"

  app "MacVim.app"

  %w[
    gview
    gvim
    gvimdiff
    gvimex
    mview
    mvim
    mvimdiff
    mvimex
    view
    vim
    vimdiff
    vimex
    vi
  ].each { |link_name| binary "#{appdir}MacVim.appContentsbinmvim", target: link_name }

  zap trash: [
    "~LibraryCachesorg.vim.MacVim",
    "~LibraryPreferencesorg.vim.MacVim.LSSharedFileList.plist",
    "~LibraryPreferencesorg.vim.MacVim.plist",
  ]
end