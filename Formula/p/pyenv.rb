class Pyenv < Formula
  desc "Python version management"
  homepage "https:github.compyenvpyenv"
  url "https:github.compyenvpyenvarchiverefstagsv2.4.17.tar.gz"
  sha256 "e2d6cfa737738f1fc228beb7b2bccb5455889ebaa1b554ef6db1960e7b347a99"
  license "MIT"
  version_scheme 1
  head "https:github.compyenvpyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+(-\d+)?)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4ca678f82f00798f662c57df1f3da88be1d20c672777fa39645895fd0ff701d0"
    sha256 cellar: :any,                 arm64_sonoma:  "234336a0f590020e08b43b79aeb188a2200f2dd7658655565c7dfe573d1da60b"
    sha256 cellar: :any,                 arm64_ventura: "b3302ba37ce6da72130211cc4d0e1760a011ca10176e9d6d973df385964dfad3"
    sha256 cellar: :any,                 sonoma:        "8c9e2e9c79a7b2039a2d53830508f7d7cbadb7e834f8c0b5694f1342e872fd5b"
    sha256 cellar: :any,                 ventura:       "41cfd9693ee695baf7aaae77c14ea67cbdf4c49d4e14f8a628c306e7e64cb4fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b4ea9d12dbf0d22ac1e4c201d5325dc28aacef63ed5ac17da8bdc3a5615d305"
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