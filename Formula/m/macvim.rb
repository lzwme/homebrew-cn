# Reference: https:github.commacvim-devmacvimwikibuilding
class Macvim < Formula
  desc "GUI for vim, made for macOS"
  homepage "https:github.commacvim-devmacvim"
  url "https:github.commacvim-devmacvimarchiverefstagsrelease-179.tar.gz"
  version "9.1.0"
  sha256 "ca515226e199cee3e59942509b9b6ae16c9cb1fc9b7e620b521807222895c710"
  license "Vim"
  head "https:github.commacvim-devmacvim.git", branch: "master"

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
    sha256 cellar: :any, arm64_sonoma:   "9eaf223d23e4aa92bb56ac0a86fe0ce886762933d502ff09429c352afd86d220"
    sha256 cellar: :any, arm64_ventura:  "5e56402e67595c3386ff4747784b742daa2e5d03e13578c1469ed374a86c78e5"
    sha256 cellar: :any, arm64_monterey: "dac8f35e0658d9e11bceeb72edf49f64446aee6d0b714ba858d765037f2f7137"
    sha256 cellar: :any, sonoma:         "dffe6661d748d85d72e87f40d1d93ad79c8b36bd18e14456e11cdae03bb268d7"
    sha256 cellar: :any, ventura:        "5d4f5ccd9c5957bda06658799845023ad7fb7c25b5eb0d68d7d29dbab1fadf95"
    sha256 cellar: :any, monterey:       "9dc522874e8a075f64a7ba4753283db9655ec06f56adf8ac4482b0daedc3a5bb"
  end

  depends_on "gettext" => :build
  depends_on "libsodium" => :build
  depends_on xcode: :build
  depends_on "cscope"
  depends_on "lua"
  depends_on :macos
  depends_on "python@3.12"
  depends_on "ruby"

  conflicts_with "ex-vi", because: "both install `vi` and `view` binaries"
  conflicts_with "vim", because: "both install vi* binaries"

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