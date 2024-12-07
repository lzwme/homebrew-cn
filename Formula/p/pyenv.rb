class Pyenv < Formula
  desc "Python version management"
  homepage "https:github.compyenvpyenv"
  url "https:github.compyenvpyenvarchiverefstagsv2.4.21.tar.gz"
  sha256 "0aea2e748d7dd4b92f8addf859b16852db5a46e809c4941861b7f05aeaf61bfd"
  license "MIT"
  version_scheme 1
  head "https:github.compyenvpyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+(-\d+)?)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9f168e47dbcb048dd7191684ea98e6546a375adaa9ab75141135172236ee7709"
    sha256 cellar: :any,                 arm64_sonoma:  "998df00ab2459df948e5559d47e8aa6d02188f61aae61ab29a8b0cea69b5c794"
    sha256 cellar: :any,                 arm64_ventura: "accfb278be2445a508ae59302468beb1f55deac4c7e4e39a6377583aed8a05c6"
    sha256 cellar: :any,                 sonoma:        "b03b9dfae158d3f193d2b04e3aabdbdb2255df7040b057b32176e81256f4615b"
    sha256 cellar: :any,                 ventura:       "bd9ad712eccbcb499aeef55d3e0259b32acac069970c9ced0c4d0cc216835cc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2dfd89cc529b90e61ccec47b387e654a3d558933011cde1ca1111c3ba6d1d005"
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