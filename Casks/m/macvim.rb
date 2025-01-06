cask "macvim" do
  version "180"
  sha256 "cbb56be27e48975135bc7f83d62480097469e8a4fdf93e7e2ae165e71cbec117"

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
  depends_on macos: ">= :high_sierra"

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