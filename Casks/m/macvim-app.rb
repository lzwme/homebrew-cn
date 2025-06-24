cask "macvim-app" do
  version "181"
  sha256 "ebcab36471c0ddfb91630eae285f57ac9a9a7cb4b233413128aba9039e6a467f"

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