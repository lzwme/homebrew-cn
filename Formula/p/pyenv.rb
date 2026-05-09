class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://ghfast.top/https://github.com/pyenv/pyenv/archive/refs/tags/v2.6.30.tar.gz"
  sha256 "7b158ec6b45200a62db9450ad3ac2141dacd25b2fe5605dcf44f3b2252dc2660"
  license "MIT"
  version_scheme 1
  compatibility_version 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a568468b1d3601217e8f1910afd61c0a27d7d7f9d1e2c8dbde0a04cf307c6a4c"
    sha256 cellar: :any,                 arm64_sequoia: "c235a610a6033a48ef2cba5179abccf77a4209565c2cd713ae3748f78ef66a49"
    sha256 cellar: :any,                 arm64_sonoma:  "3ccd8e71e0159c3658ed0bb15f0c0f35d36987c00eb4f6e337bbf8a3b3e27e42"
    sha256 cellar: :any,                 tahoe:         "fbd2e2d39358e543e40f8ad3213f385dbe11c3e10345086e898da92c225dbd6f"
    sha256 cellar: :any,                 sequoia:       "f2ed107f121f9fc2a7b59b384ad5bfd45af2740f2d3ec28a86b5ee0c40d9f3e3"
    sha256 cellar: :any,                 sonoma:        "109af97a50b3027a3ae5b016191e148b250802de943bb992630c95621ea49da7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3da03f606bac1c971b139c1b5a6b7cef619ffac4dc777bed979a6255a293ba36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b575a04e4d7ae25a8e9e05305753b6f21c04567b9ccde591ebe60ea193091cb"
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

  on_linux do
    depends_on "zlib-ng-compat"
  end

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