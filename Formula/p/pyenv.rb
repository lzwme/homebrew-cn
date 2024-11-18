class Pyenv < Formula
  desc "Python version management"
  homepage "https:github.compyenvpyenv"
  url "https:github.compyenvpyenvarchiverefstagsv2.4.18.tar.gz"
  sha256 "c1ec5996fa8062ec460f83fd7b513efbbc3ed659feee4471ac5a4520c1ddbfbd"
  license "MIT"
  version_scheme 1
  head "https:github.compyenvpyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+(-\d+)?)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f87515fc5c69c33426582e7da703d1cedecb6b2fb3129d0fe4712dba71d8eb6a"
    sha256 cellar: :any,                 arm64_sonoma:  "38eb418d89701c581ec863ba23f8fb1c62435c6e585f5bed1e731204f37154e0"
    sha256 cellar: :any,                 arm64_ventura: "3b784649fd9a919b45db62abdbd02cdf5d5b8099ebf106ca6ffdc0212dc5420e"
    sha256 cellar: :any,                 sonoma:        "56ad5b573113b173d9d9d815617b5e21b2b7f29f0f9c5e6670f2fbc876666b0b"
    sha256 cellar: :any,                 ventura:       "7cf3451477ec2d5cb27a86da0c646b3ad4bfa00dc58369f3e4bc6187faab7266"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba4842cc4f74f69f5be79890c2454c3675eb8fcb8bbc30c35b7b9c2038a5aa59"
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