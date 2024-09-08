class Pyenv < Formula
  desc "Python version management"
  homepage "https:github.compyenvpyenv"
  url "https:github.compyenvpyenvarchiverefstagsv2.4.12.tar.gz"
  sha256 "a67b092775f2b26defa385fb29b66cc3681f55b044eca5bffe53c911de4ab239"
  license "MIT"
  version_scheme 1
  head "https:github.compyenvpyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+(-\d+)?)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "df3a3424a5a7aec3ce6d3c4e874b44b4e0eef0feb322d0dfa50f044669d96840"
    sha256 cellar: :any,                 arm64_ventura:  "2852285936a1d35ecb409c7c48fe830c880b124620e82e7c0f4c988ef961302d"
    sha256 cellar: :any,                 arm64_monterey: "8f8b6a020b52c38453addc56623cf54154266ac3971599b5b53f432d5f3703a6"
    sha256 cellar: :any,                 sonoma:         "2b4149ba7a5bfd0dc51f9f79aebc2e592d1e8d99372ffc41dda598a8194b60f8"
    sha256 cellar: :any,                 ventura:        "5716572b7976433d6762cbdadef738798966c185b9792eb32acbabd1403bb724"
    sha256 cellar: :any,                 monterey:       "e2df95bd2620261b54ff8b123dd82f4a5c91437a8282ac28ce0219e9c056df40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e94ee2efe51b69049e756444616861939d5ab7bb2f3e1f677215fb761517d963"
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