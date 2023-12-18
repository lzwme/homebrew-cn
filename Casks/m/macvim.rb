cask "macvim" do
  version "178"
  sha256 "9efe173a7906f0e83e93a4c71eb768a2bbf58d4af1e881cf55b4b6c9e280ee0f"

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