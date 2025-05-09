class Pyenv < Formula
  desc "Python version management"
  homepage "https:github.compyenvpyenv"
  url "https:github.compyenvpyenvarchiverefstagsv2.5.7.tar.gz"
  sha256 "8f8a9269e8ac676001b57291a002e08c85c1921185bcfb517d2db569b4fdb158"
  license "MIT"
  version_scheme 1
  head "https:github.compyenvpyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+(-\d+)?)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e92da67e25841718343f019895fdd466b1f087a434c9c017a6f6be4cd56bd985"
    sha256 cellar: :any,                 arm64_sonoma:  "6fc91b1ce33f9b47111bdbfb69189cdde7ff2b345515bd95cdad8a9f5c5fdb5c"
    sha256 cellar: :any,                 arm64_ventura: "6c4ccadbcca559187fb4bd96ac4460a0aba5aee91bcc540b88ad8a441fd18fd9"
    sha256 cellar: :any,                 sonoma:        "5176551daf7dcd43fa132b52c619f1932b43a4ac92c4186aac9a9f87fc8668e3"
    sha256 cellar: :any,                 ventura:       "5bec0b7618ddd7ae565131343bb8bdf95b0560980c94ac787559cca9413a399b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7639f6be19a307f91505bdc31dcd2c8f4fab2d586d5b3b9454cb133441a52e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82e11c654d55d1cfbc229ddc6766c0e28185f3154e67aa37337083fd99458d70"
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
    inreplace "libexecpyenv", "usrlocal", HOMEBREW_PREFIX
    inreplace "libexecpyenv-rehash", "$(command -v pyenv)", opt_bin"pyenv"
    inreplace "pyenv.drehashsource.bash", "$(command -v pyenv)", opt_bin"pyenv"

    system "srcconfigure"
    system "make", "-C", "src"

    prefix.install Dir["*"]
    %w[pyenv-install pyenv-uninstall python-build].each do |cmd|
      bin.install_symlink "#{prefix}pluginspython-buildbin#{cmd}"
    end

    share.install prefix"man"

    # Do not manually install shell completions. See:
    #   - https:github.compyenvpyenvissues1056#issuecomment-356818337
    #   - https:github.comHomebrewhomebrew-corepull22727
  end

  test do
    # Create a fake python version and executable.
    pyenv_root = Pathname(shell_output("#{bin}pyenv root").strip)
    python_bin = pyenv_root"versions1.2.3bin"
    foo_script = python_bin"foo"
    foo_script.write "echo hello"
    chmod "+x", foo_script

    # Test versions.
    versions = shell_output("eval \"$(#{bin}pyenv init --path)\" " \
                            "&& eval \"$(#{bin}pyenv init -)\" " \
                            "&& #{bin}pyenv versions").split("\n")
    assert_equal 2, versions.length
    assert_match(\* system, versions[0])
    assert_equal("  1.2.3", versions[1])

    # Test rehash.
    system bin"pyenv", "rehash"
    refute_match "Cellar", (pyenv_root"shimsfoo").read
    assert_equal "hello", shell_output("eval \"$(#{bin}pyenv init --path)\" " \
                                       "&& eval \"$(#{bin}pyenv init -)\" " \
                                       "&& PYENV_VERSION='1.2.3' foo").chomp
  end
end