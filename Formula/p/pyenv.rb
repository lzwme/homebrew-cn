class Pyenv < Formula
  desc "Python version management"
  homepage "https:github.compyenvpyenv"
  url "https:github.compyenvpyenvarchiverefstagsv2.4.2.tar.gz"
  sha256 "337ad07dc8f4bb1cd132c27051320cc20b67410b819462b3c78eb6642f304b3f"
  license "MIT"
  version_scheme 1
  head "https:github.compyenvpyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+(-\d+)?)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "991ab2c2ad9f9052b31b02f8bc65c950a39dadd3526c031569d8107f8443c9e8"
    sha256 cellar: :any,                 arm64_ventura:  "6e93f5c875d1e1afae74e1630e6f119a6963c12acaa0684c1733c7f16b3bfd58"
    sha256 cellar: :any,                 arm64_monterey: "8b4f31d0e373d4fd3e7f8a1eb0586e0b2e440729e403c8a6c6a13d8c4dad59f8"
    sha256 cellar: :any,                 sonoma:         "b2cc0c75da4410ddce73750e9c274eac9203507b001ece52824548a7a6ddd783"
    sha256 cellar: :any,                 ventura:        "d68cfe18906e5ba10bb5412550d5aac3bdc1a159bea24df3b45e6ac0c9b22111"
    sha256 cellar: :any,                 monterey:       "3521eaf2fe2240efbf6b9e5f5d8b41cc3048ebe0666a1607e08fc680994e157b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "342fa0640f4a890036f31dc9f7a20a3c4ed3021f267e0781176cf14990403e62"
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