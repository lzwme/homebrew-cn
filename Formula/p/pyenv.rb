class Pyenv < Formula
  desc "Python version management"
  homepage "https:github.compyenvpyenv"
  url "https:github.compyenvpyenvarchiverefstagsv2.4.7.tar.gz"
  sha256 "0c0137963dd3c4b356663a3a152a64815e5e4364f131f2976a2731a13ab1de4d"
  license "MIT"
  version_scheme 1
  head "https:github.compyenvpyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+(-\d+)?)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d7bc355eb008a6e6263a8140b33dd84d4d0cf3abd66b6af9d47ef6f1f0fa9ea5"
    sha256 cellar: :any,                 arm64_ventura:  "f0d6501f18cdd8f695f5486d2a05aad357767fc5895b307846625c1e94218189"
    sha256 cellar: :any,                 arm64_monterey: "6f28a8ef137293e68c934e803db7ac7e431f5cb45f2fb7ada5ae8ac3d89fe8c9"
    sha256 cellar: :any,                 sonoma:         "225c342126303406c75839014db0082d138f500241d712c39ea7ecb4a01217d6"
    sha256 cellar: :any,                 ventura:        "f6c5a1667bae2bacb796574446736286804eb91e38456c0c8ede2ecc5b4f9a92"
    sha256 cellar: :any,                 monterey:       "d6975bf6b3552e91c25431c745ea2282e683c101edc14f2b199f9fe9ed14f9d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b26ab45e3bfe8281134ac43812ee27e4ae379fa79e7de76ac41f4ad7c7d1a55b"
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