class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://ghfast.top/https://github.com/pyenv/pyenv/archive/refs/tags/v2.6.12.tar.gz"
  sha256 "75fe91b18e617bf0261e40901d3ebc3e3c1b94b0b62da2fd7dddd1778f45dcb7"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b3805e941f5429f443e9d47cc2d1e5cc73ae69112e244021ada98a3986ebbaa9"
    sha256 cellar: :any,                 arm64_sequoia: "a549634e8cae374641830023ef1d8e5935449bc2ae0ad84a7f369d644c28d449"
    sha256 cellar: :any,                 arm64_sonoma:  "06bfdb44f62390788e4539dd4cb8083298465572838dc2818d6daa918addd672"
    sha256 cellar: :any,                 sonoma:        "d4b591d91859b7c265f5a976c7828c4aa2ed5b0fc5120fd230b09bf61be89071"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c4cfdafe02636cb7901da97d68e87369dccb06e5933c6f44f8c335acf65c3dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96e58b8b35d1e1d238a8f0d7968268598e99373a0899f6bef8f1f1af706de882"
  end

  depends_on "autoconf"
  depends_on "openssl@3"
  depends_on "pkgconf"
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