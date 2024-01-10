# Reference: https:github.commacvim-devmacvimwikibuilding
class Macvim < Formula
  desc "GUI for vim, made for macOS"
  homepage "https:github.commacvim-devmacvim"
  license "Vim"
  revision 1
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

    # Backport Sonoma tabs fix. Remove in the next release.
    patch do
      url "https:github.commacvim-devmacvimcommite9167c29dbf3dd5bb80b48c6425c7b20301a8d44.patch?full_index=1"
      sha256 "cdeff4ea17bd3f67022f17b78d6ccf9bc8a90b4b1a18b721bd3f65103bfef04e"
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
    sha256 cellar: :any, arm64_sonoma:   "dd0005e3a3e47a86e900c9484e56d40ac6346907926bdb98bb98d9ef4ca356c7"
    sha256 cellar: :any, arm64_ventura:  "34d743177e5aeeb13e71ee0e523c40ce7303456a8205d6fa095f8d53ad597bda"
    sha256 cellar: :any, arm64_monterey: "b24a33025671ced7bdeb025756e291dd63188462f1ae84ee118758a332b3a1dc"
    sha256 cellar: :any, sonoma:         "c4f0f1b0b3a5033607bdefbd795bce7d1d11fad1ed762875a6b76a294abe3bd0"
    sha256 cellar: :any, ventura:        "a51bc466df511e47c03b775dddb7ae37a39a068eb4cf9e66616ff50d795038ca"
    sha256 cellar: :any, monterey:       "62ee4cadde561517dc80d7aa2fc94e3bb2b1170aa6334abc90a900f27018bbdb"
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