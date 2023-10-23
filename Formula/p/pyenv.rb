class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://ghproxy.com/https://github.com/pyenv/pyenv/archive/refs/tags/v2.3.31.tar.gz"
  sha256 "3b2c08d71ff72c80e95fd7aebdfd54f722cbfffdd886da15728bb9b335958c13"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "caae3af6d1c416ccb915b9355cbf97dcb0f7ec53866ba1a1b6ab621b03f443ff"
    sha256 cellar: :any,                 arm64_ventura:  "09e8f3e2c0b212876d3ab36b395ebf786b9a1a4bd0ff493ce42cb017c78ad1eb"
    sha256 cellar: :any,                 arm64_monterey: "4a0114d9e0b263152f46179c86cb87f8b5b78f154f01732891511c5e0aa3c4ef"
    sha256 cellar: :any,                 sonoma:         "630c0f8ae2d780fc61f0167e03f58fbb2f7cc09625f734365ba76d89e29e028b"
    sha256 cellar: :any,                 ventura:        "b709fe95342da6dde20cc318b092c9680ec28ba2c1fb89bf84efd818315c3d28"
    sha256 cellar: :any,                 monterey:       "ecd08810bed8d5e11861f4377a8bee9e2d86ab8b23c6ec1d81c8eb217bbd4c02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1799bf0f2d95f1ab861495ecca201d16a6b9059ae8fcb4027e46cdc8ae0a3700"
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