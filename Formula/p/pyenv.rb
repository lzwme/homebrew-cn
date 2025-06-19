class Pyenv < Formula
  desc "Python version management"
  homepage "https:github.compyenvpyenv"
  url "https:github.compyenvpyenvarchiverefstagsv2.6.3.tar.gz"
  sha256 "f558daace68867ad33e3d0f670fc04cf98d2a586c33eb5cbe5963ec46de422c3"
  license "MIT"
  version_scheme 1
  head "https:github.compyenvpyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+(-\d+)?)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3706882e55b1c36c67ba22771b3cd5009d041f5a118ec07a195f5f5f7e4fbfde"
    sha256 cellar: :any,                 arm64_sonoma:  "90e0bbd75cf27f9e91c0e46f7fdb348a4550c792e68811f096f7a6192120e678"
    sha256 cellar: :any,                 arm64_ventura: "9de68684b721f80bbe3c02a55ecb7511df6dbcee0b7acba9533d3ae78eeaaf99"
    sha256 cellar: :any,                 sonoma:        "3c20a7741b4cc82cd9c1595925de8f1fba7b1737991d359f354a871e802d68d8"
    sha256 cellar: :any,                 ventura:       "e5a002f8d8cfd1644de277fb171bd92c6f1cd8aaca1f57f566bc2d74b6d90bb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ccfcea6135bc9c7969895dcf3c01421ad836b2281dacf8ad125c4108f3ed56a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4093367183946c1a7f25db6879f048822196c0f84d59735bb3a9dba4d5fa87f"
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