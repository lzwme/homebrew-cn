class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://ghproxy.com/https://github.com/pyenv/pyenv/archive/refs/tags/v2.3.23.tar.gz"
  sha256 "c3decc7f941456ea65a516721eef0c22070010f38dd30662435456c70a151121"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a8ddcbe1be3c6f02e52c6dc072929e1814d198fd4e2b958858656463b29024f6"
    sha256 cellar: :any,                 arm64_monterey: "c823efd3c147c0b7b7f40cfd4cae3993314e3171854383680e2a24790155ab06"
    sha256 cellar: :any,                 arm64_big_sur:  "7378b859a1281c01adf4bc74f70f245de68d37110c539af4db10a16f11f6f2c2"
    sha256 cellar: :any,                 ventura:        "a10b2c5f70f51511ebed58cd0cb611c3eee22e9143ec72224da6963d0c1b3443"
    sha256 cellar: :any,                 monterey:       "b2e9408c8652e0f4c8d2fbd09a308e7271b8f988d7ca452b7799a70ec1676d4c"
    sha256 cellar: :any,                 big_sur:        "e0929aa0b150c10dca26a3b6b8b3a74d07bb179aef750d374ece2dfd8d27863a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06b54a2c6274969631b38237138245aaf8e3d6712f0caf0be2b8cc802095d713"
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