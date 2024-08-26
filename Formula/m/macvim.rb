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
    rebuild 1
    sha256 cellar: :any, arm64_sonoma:   "87c5d934d736ea8314ad6360b89fb37f52d97570303b0aa76a02e831b4846563"
    sha256 cellar: :any, arm64_ventura:  "71b6b7c24d64a4e44d1cb28cac091cab2eb24b3d4b56d21fb7476f45ade1b1e2"
    sha256 cellar: :any, arm64_monterey: "4af76a0db530fcc0c45ae73739e9b97cded10a112e8bdfaf0814f4dda6f5e107"
    sha256 cellar: :any, sonoma:         "9d5d1e4ccd460f1bb37da8af8842f223bc625d5e59ad92d16b626fb4761079c9"
    sha256 cellar: :any, ventura:        "044f2feb442fa13e91a47952d22000933382c51dc2ed936cec1f66c5ff20278c"
    sha256 cellar: :any, monterey:       "2436864107c5f907dea2495ed1148c26905ebc6eeda93d1f781f2c690ae42170"
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
    %w[gvimtutor mvim vimtutor xxd].each { |e| bin.install_symlink prefix"MacVim.appContentsbin#{e}" }

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