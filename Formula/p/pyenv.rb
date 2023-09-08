class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://ghproxy.com/https://github.com/pyenv/pyenv/archive/refs/tags/v2.3.26.tar.gz"
  sha256 "6f8217029745f2257566d61f4c2a702b00653a9de0a08e4e0de10282369d962e"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bc063ee50eed951ffaf1e5e544c872f7101476082f0960fffcb46952cdc04747"
    sha256 cellar: :any,                 arm64_monterey: "a73f19992c630ca004f66c90354e668a78d62bc475a632b9ee041a4434b29cbb"
    sha256 cellar: :any,                 arm64_big_sur:  "95e42a48015e42b4cb9853792561aaa4eaca0f292b58d0f62a198f26032ad2ea"
    sha256 cellar: :any,                 ventura:        "d1b7295b5be8e37343e1ce5130b885e9b51458173891a24a40d1aa2e4d4c797d"
    sha256 cellar: :any,                 monterey:       "26980179f22da6cad3e47d96be65565ac9bd0b10bc59a2982c02fc76e92c92b6"
    sha256 cellar: :any,                 big_sur:        "6730411987051f828abc2648f32b5bf6a82095595b6c3cb7f34085be9069b7ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ad4c448487f7d564751bee1030a5e5cf5b2660eacd22999c9d24bf810819d40"
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