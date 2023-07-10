class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://ghproxy.com/https://github.com/pyenv/pyenv/archive/refs/tags/v2.3.22.tar.gz"
  sha256 "6ae14431f7ca0e0c0ad721ba1373ddcf6f65b2b628533bdf3acf99320b8d7056"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "77b3b2bb54c95d1feb48bd5b4b83b00fd6fa91907239331dd2f058f98b294e62"
    sha256 cellar: :any,                 arm64_monterey: "7eff22f5364d5e46275ab9dcfaecd8005e24b2a7732abedbcac494a9216c1bf6"
    sha256 cellar: :any,                 arm64_big_sur:  "8196c3613da35f37d2953fd4dd3fe216b3adaae5deca4eafb77fa5e9296c2413"
    sha256 cellar: :any,                 ventura:        "94c80ee8a8bdd7cd3ea5f176ac72dcfb05aa432e83f5165d6f9b5e0b8504d598"
    sha256 cellar: :any,                 monterey:       "21bcceca3a48d4a0a62d91367582aa3ca8f4e368966cfa6824198595a948e9ee"
    sha256 cellar: :any,                 big_sur:        "ce93db7397282a765175b44e5b53797877b59761d3b4ae46345a20820d27bb43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "350eeb5f925813f78110c2e2492bfae3da6d71ba0e931124ed90a78b39fa9137"
  end

  depends_on "autoconf"
  depends_on "openssl@3"
  depends_on "pkg-config"
  depends_on "readline"

  uses_from_macos "python" => :test
  uses_from_macos "bzip2"
  uses_from_macos "libffi"
  uses_from_macos "ncurses"
  uses_from_macos "xz"
  uses_from_macos "zlib"

  def install
    inreplace "libexec/pyenv", "/usr/local", HOMEBREW_PREFIX
    inreplace "libexec/pyenv-rehash", "$(command -v pyenv)", opt_bin/"pyenv"
    inreplace "pyenv.d/rehash/source.bash", "$(command -v pyenv)", opt_bin/"pyenv"

    system "src/configure"
    system "make", "-C", "src"

    prefix.install Dir["*"]
    %w[pyenv-install pyenv-uninstall python-build].each do |cmd|
      bin.install_symlink "#{prefix}/plugins/python-build/bin/#{cmd}"
    end

    share.install prefix/"man"

    # Do not manually install shell completions. See:
    #   - https://github.com/pyenv/pyenv/issues/1056#issuecomment-356818337
    #   - https://github.com/Homebrew/homebrew-core/pull/22727
  end

  test do
    # Create a fake python version and executable.
    pyenv_root = Pathname(shell_output("#{bin}/pyenv root").strip)
    python_bin = pyenv_root/"versions/1.2.3/bin"
    foo_script = python_bin/"foo"
    foo_script.write "echo hello"
    chmod "+x", foo_script

    # Test versions.
    versions = shell_output("eval \"$(#{bin}/pyenv init --path)\" " \
                            "&& eval \"$(#{bin}/pyenv init -)\" " \
                            "&& #{bin}/pyenv versions").split("\n")
    assert_equal 2, versions.length
    assert_match(/\* system/, versions[0])
    assert_equal("  1.2.3", versions[1])

    # Test rehash.
    system bin/"pyenv", "rehash"
    refute_match "Cellar", (pyenv_root/"shims/foo").read
    assert_equal "hello", shell_output("eval \"$(#{bin}/pyenv init --path)\" " \
                                       "&& eval \"$(#{bin}/pyenv init -)\" " \
                                       "&& PYENV_VERSION='1.2.3' foo").chomp
  end
end