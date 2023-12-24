# Reference: https:github.commacvim-devmacvimwikibuilding
class Macvim < Formula
  desc "GUI for vim, made for macOS"
  homepage "https:github.commacvim-devmacvim"
  license "Vim"
  head "https:github.commacvim-devmacvim.git", branch: "master"

  stable do
    url "https:github.commacvim-devmacvimarchiverefstagsrelease-178.tar.gz"
    version "9.0.1897"
    sha256 "ec614f8609aa61948e01c8ea57f133e29c9a3f67375dde65747ba537d8a713e6"

    # Backport Python 3.12 fix. Remove in the next release.
    patch do
      url "https:github.comvimvimcommitfa145f200966e47e11c403520374d6d37cfd1de7.patch?full_index=1"
      sha256 "b449dbcb51e6725b5365a12f987ebe1265bdaf1665bbe3bce4566478957d796d"
    end
  end

  # The stable Git tags use a `release-123` format and it's necessary to check
  # the GitHub release description to identify the Vim version from the
  # "Updated to Vim 1.2.3456" text.
  livecheck do
    url :stable
    regex(Updated\s+to\s+Vim\s+v?(\d+(?:\.\d+)+)i)
    strategy :github_latest do |json, regex|
      match = json["body"]&.match(regex)
      next if match.blank?

      match[1]
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_sonoma:   "a6fb07ec4d91f956f9d2f63b4dfee6b43e5445471bbd045974ceb727c016ff1e"
    sha256 cellar: :any, arm64_ventura:  "d81e839c80d4e276efd3c793c60f993da4909e51bd24066a5cc10f382393b366"
    sha256 cellar: :any, arm64_monterey: "38b9f74342d05c8ac0bdfdeb6a5f0a58cd8bc253cbc162c66d55a3983514e6d4"
    sha256 cellar: :any, sonoma:         "9642048a7c2efa353e444e82a02d8a9c44a8e5b46dead137c70821d256acd2ba"
    sha256 cellar: :any, ventura:        "3a4c3713f26d68821c91cb78662797727e58735eef03ed63a6b2d7503bacddb4"
    sha256 cellar: :any, monterey:       "fa373200374d70dfc84ce37872baaa4a31476ba582691fbe28f17cea9cfc003a"
  end

  depends_on "gettext" => :build
  depends_on "libsodium" => :build
  depends_on xcode: :build
  depends_on "cscope"
  depends_on "lua"
  depends_on :macos
  depends_on "python@3.12"
  depends_on "ruby"

  conflicts_with "vim", because: "vim and macvim both install vi* binaries"

  def install
    # Avoid issues finding Ruby headers
    ENV.delete("SDKROOT")

    # MacVim doesn't have or require any Python package, so unset PYTHONPATH
    ENV.delete("PYTHONPATH")

    # We don't want the deployment target to include the minor version on Big Sur and newer.
    # https:github.comHomebrewhomebrew-coreissues111693
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

    # make sure that CC is set to "clang"
    ENV.clang

    system ".configure", "--with-features=huge",
                          "--enable-multibyte",
                          "--enable-perlinterp",
                          "--enable-rubyinterp",
                          "--enable-tclinterp",
                          "--enable-terminal",
                          "--with-tlib=ncurses",
                          "--with-compiledby=Homebrew",
                          "--with-local-dir=#{HOMEBREW_PREFIX}",
                          "--enable-cscope",
                          "--enable-luainterp",
                          "--with-lua-prefix=#{Formula["lua"].opt_prefix}",
                          "--enable-luainterp",
                          "--enable-python3interp",
                          "--disable-sparkle",
                          "--with-macarchs=#{Hardware::CPU.arch}"
    system "make"

    prefix.install "srcMacVimbuildReleaseMacVim.app"
    bin.install_symlink prefix"MacVim.appContentsbinmvim"

    # Create MacVim vimdiff, view, ex equivalents
    executables = %w[mvimdiff mview mvimex gvim gvimdiff gview gvimex]
    executables += %w[vi vim vimdiff view vimex]
    executables.each { |e| bin.install_symlink "mvim" => e }
  end

  test do
    output = shell_output("#{bin}mvim --version")
    assert_match "+ruby", output
    assert_match "+gettext", output
    assert_match "+sodium", output

    # Simple test to check if MacVim was linked to Homebrew's Python 3
    py3_exec_prefix = shell_output(Formula["python@3.12"].opt_libexec"binpython-config --exec-prefix")
    assert_match py3_exec_prefix.chomp, output
    (testpath"commands.vim").write <<~EOS
      :python3 import vim; vim.current.buffer[0] = 'hello python3'
      :wq
    EOS
    system bin"mvim", "-v", "-T", "dumb", "-s", "commands.vim", "test.txt"
    assert_equal "hello python3", (testpath"test.txt").read.chomp
  end
end