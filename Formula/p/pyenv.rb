class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://ghproxy.com/https://github.com/pyenv/pyenv/archive/refs/tags/v2.3.34.tar.gz"
  sha256 "4d4f9fbbdd5cb8926feba745fad3c000a70af67d4cb4f59f53c9f470b44e8579"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c9f07c9d7c44e792a65a23858f2662937b48abd2880ec9244ecefa85f9be0d35"
    sha256 cellar: :any,                 arm64_ventura:  "ca60e7da9e2760559af5933f35711af104c9fae6d33b4f1536a995c29ab7bfbf"
    sha256 cellar: :any,                 arm64_monterey: "0045c1597bc8dba5d596cfe14bfa2f8f9c780405ecfaf83a3b3e1728c61224d8"
    sha256 cellar: :any,                 sonoma:         "7926e60abd18643669caa8ec429f5794188e46dd3de5a81628b149fdcec5abad"
    sha256 cellar: :any,                 ventura:        "aadfade62477fed65bb3c175ff32766077ad01e32305e5682d6f9c4cc6033dc3"
    sha256 cellar: :any,                 monterey:       "c9e4dceb480f214a48e9e5386b1ba48adfbaa366c29152799ec022105bed8820"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c37e1faafec41cc65f955ea5868896c47a20ddb496961e257afd82c79e55065b"
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