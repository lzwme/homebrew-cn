class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://ghfast.top/https://github.com/pyenv/pyenv/archive/refs/tags/v2.6.32.tar.gz"
  sha256 "f9b0bddb6e4f99a2d57bb09dca1fa804586e85aa8739215838a8b8c44c4f86aa"
  license "MIT"
  version_scheme 1
  compatibility_version 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7427af31dde58b9a4caa58156508dac3d8db382b2fde39a32b78cbe6cb975ad6"
    sha256 cellar: :any, arm64_sequoia: "e95092d495a79707b3d04b97269c3378106f6ef536c2f71f751db3fec9cfcf39"
    sha256 cellar: :any, arm64_sonoma:  "42dd60a7582431460762e9d93339d7ad1b22fd58e9924ca64de56c30e84f9619"
    sha256 cellar: :any, tahoe:         "f5d890b46a846a12ac7f68fe6fe3ef383b39a3581639fa29e9ebd6e7b2426768"
    sha256 cellar: :any, sequoia:       "a5223ac13692def42dd459d2593efa8a76b5b1df1cecb499e9f8ac10c6fbe1e6"
    sha256 cellar: :any, sonoma:        "1fd87a36fa9341e358382825aaf5da7ebb1cff92a431a27c020471d474dd6312"
    sha256 cellar: :any, arm64_linux:   "12d6f3f778ce9fd4c212cd14ff87645f9765653d3cf7c1a707fddefa3ca4eaf5"
    sha256 cellar: :any, x86_64_linux:  "d2c35587b382aa7ebcca627328f859427c390d33b465770cdc13ff1e4dc495b1"
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