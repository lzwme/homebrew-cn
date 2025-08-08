class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://ghfast.top/https://github.com/pyenv/pyenv/archive/refs/tags/v2.6.6.tar.gz"
  sha256 "df835a121456102be9df303c0d7ac688572aba07cc90b23ac611f89e6911a1dc"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "216be7176ad98deaf6ab8ae3339ece781e577d1f30555d0076582bde5d096721"
    sha256 cellar: :any,                 arm64_sonoma:  "1fd64e01bbf1cd3b6466ac8b2f6a2ce03e42b21f9abc7d6ac9ea55074accfe11"
    sha256 cellar: :any,                 arm64_ventura: "87d39a9f3023ffa2eb8cd481c780352851d08da1a0a5b7a0ece3b86c975c8c60"
    sha256 cellar: :any,                 sonoma:        "4c98047d78597c8f33ad50f44002125cc27a909cb4164323e9d446e68edeae86"
    sha256 cellar: :any,                 ventura:       "71301806dc8c1e0428e47439a84d194a17665b8d6c8b7aae1ade5d5931e3f8eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9fb75b7385a336ff15e5b08e124fac51e7c3fb9435eb6fc659b4b35a627dca0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6533665a53cd57a36cc906b074939996f8b707651e552215d6d3a73dddca1180"
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