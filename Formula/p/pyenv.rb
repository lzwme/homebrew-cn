class Pyenv < Formula
  desc "Python version management"
  homepage "https:github.compyenvpyenv"
  url "https:github.compyenvpyenvarchiverefstagsv2.5.4.tar.gz"
  sha256 "f276fafa7509d31ed723fdb90c260876a3b0f49ee98306aff8bf368f5ebd3d97"
  license "MIT"
  version_scheme 1
  head "https:github.compyenvpyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+(-\d+)?)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5ce538e8323368cf9709cf39e4f70c738a271872e0051422e8343283fb96bcc9"
    sha256 cellar: :any,                 arm64_sonoma:  "c49a34de4655a712d889a80c959d6026ffde55dee33ddeccb7844321dec661d4"
    sha256 cellar: :any,                 arm64_ventura: "a61158edfa568d0ed26daf71b3900c4603287898577872bcac6cc7b2fe62c4ab"
    sha256 cellar: :any,                 sonoma:        "9b1bddfa59dc37ea1c8f199ed3c498cd91d993db3c3fd84e91d11288ad11e83e"
    sha256 cellar: :any,                 ventura:       "7002c316524abb07bc03e86daf0c500b55eb18dc87c7140869683df2091a1b29"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9f330c81957157a3c371ef575e09d0b7c4f092b1ee130fac25805677802a703"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64565f42a626bd823ca52452d50b3539bb4c2d73dfed0e2bbdf29947c1473fbc"
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