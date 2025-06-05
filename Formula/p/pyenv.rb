class Pyenv < Formula
  desc "Python version management"
  homepage "https:github.compyenvpyenv"
  url "https:github.compyenvpyenvarchiverefstagsv2.6.1.tar.gz"
  sha256 "55910d7f5f2d533dd6336da1dd286a658fef9e689a56684ef8ccc07fc6b82573"
  license "MIT"
  version_scheme 1
  head "https:github.compyenvpyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+(-\d+)?)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "19a52c9036c3babd764231479a6fee651fa95475927c1b9f2d91428652601f61"
    sha256 cellar: :any,                 arm64_sonoma:  "0561503c161033a97a34f8d7176c13b2e71c523b31bba55e54c167c9ec1335fd"
    sha256 cellar: :any,                 arm64_ventura: "69a113f0752ff2c9d90a80551a7e7fe7e4c2f0866c500087ba1fe57252af6201"
    sha256 cellar: :any,                 sonoma:        "d1318666b9c108325316d1e07641e23d298d34cb633ce2ce329bf8663005b9a2"
    sha256 cellar: :any,                 ventura:       "8da470a222daf576c39194bad937247a8ac6df3f8e921f6f07832ad75feb88a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ebe41bd070264cb34e0a50e8b1ef19a2f776533ae3a1b5590a12443b56ca8d22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ecd79711833813dd631cb3b7269cbe46490fb1f001f874634b7f68f63f37260"
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