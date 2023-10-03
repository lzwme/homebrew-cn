class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://ghproxy.com/https://github.com/pyenv/pyenv/archive/refs/tags/v2.3.28.tar.gz"
  sha256 "0d9d41f70e641cd0a626a234fc97523f8817f8de02d1a3aa046d5b39a3e1e082"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "962dd70e85a5ed9150c79c0ce0c2ed31996f73adcdd3b1030db24f46499cbf6b"
    sha256 cellar: :any,                 arm64_ventura:  "d1f4880c1b122363a743aef9b76a882db5c3128fc495e6ec0b36ea1e345b6a86"
    sha256 cellar: :any,                 arm64_monterey: "1628957496f8387039b97c7b2479c16f8d7e8ecf986d84cca36867b7470413d9"
    sha256 cellar: :any,                 sonoma:         "fa6538ed25407f9f5b7d3f33ce0b26bcf6e6947d37c37d44c5d74146b0eadf34"
    sha256 cellar: :any,                 ventura:        "1dbdd96e7ecc5bb02531c6559eb37a9d38142c45184d299dc455b5e48b808d49"
    sha256 cellar: :any,                 monterey:       "a9f10166b844ba52b5329d2496e45123b3f052e45b22e4ec1419fe4b3c78b297"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7120038bee72c16d96916625fdaae611329d76039610f41e625c53952ca85547"
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