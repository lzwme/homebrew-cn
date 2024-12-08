class Pyenv < Formula
  desc "Python version management"
  homepage "https:github.compyenvpyenv"
  url "https:github.compyenvpyenvarchiverefstagsv2.4.22.tar.gz"
  sha256 "70dcf91b52a4424beea9139a5100781310d2186f4891b2c2f3e537e15e2494fa"
  license "MIT"
  version_scheme 1
  head "https:github.compyenvpyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+(-\d+)?)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d60a962039c3c0c1f0b0f979efe00549a4690250696087724d57a586e583dc8c"
    sha256 cellar: :any,                 arm64_sonoma:  "6db0c350e0eac0cdd953076187dc135bd6bdf5d6a2722b85fd29b56eda028108"
    sha256 cellar: :any,                 arm64_ventura: "ae4a7c6d6a657a146abe1ec07e7dc1353b5a3bb8fc27dff017fbbbd9b20f7ee8"
    sha256 cellar: :any,                 sonoma:        "d841e50f1e10f9c04aa622e5d6eb1ea3a739ffa077408e7dcad7d5b4d7337d24"
    sha256 cellar: :any,                 ventura:       "24ad0e58c87b8e64386c182d6e0c0a48ce7ba1b4a5bca742e62c5c9e753faa54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49396d4a41fbd85676dfdba0022e9732b63d69543b8d0db1be145b54bb343b89"
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