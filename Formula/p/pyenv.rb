class Pyenv < Formula
  desc "Python version management"
  homepage "https:github.compyenvpyenv"
  url "https:github.compyenvpyenvarchiverefstagsv2.4.9.tar.gz"
  sha256 "df3b2ad4ff129f8c74d6d9b369a8c7002033c63e246c7bc20d8357f10bc6e8e7"
  license "MIT"
  version_scheme 1
  head "https:github.compyenvpyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+(-\d+)?)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b17786a8edc9495c216bda2e930bb4fa7b59b28b4c92765764b76ee75df35d00"
    sha256 cellar: :any,                 arm64_ventura:  "a50fee934a15857a387b5b0b3788191e3ce29a1e424834332934d84fb69ff47d"
    sha256 cellar: :any,                 arm64_monterey: "832a73c458cb127630f7fca38ad9ff9c70f05ec37748c1517ac38876d88bc79d"
    sha256 cellar: :any,                 sonoma:         "a2788faffa16b7e5157875d2510d46f8ccc325971da0b1a41cb5a62ddc27af8c"
    sha256 cellar: :any,                 ventura:        "471f137e1723cc123bad8c1d2ac20bd623a712ed808daae222c8b10619d1becc"
    sha256 cellar: :any,                 monterey:       "f604868f88ecd142ec0ab9f500013f524df45cc565e4f8289736f129c8cdb304"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "600b8a6592a9040ba93a97a09d4ce81cc239d9ff3994175d1238e650f351a065"
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