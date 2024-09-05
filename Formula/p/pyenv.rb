class Pyenv < Formula
  desc "Python version management"
  homepage "https:github.compyenvpyenv"
  url "https:github.compyenvpyenvarchiverefstagsv2.4.11.tar.gz"
  sha256 "92db49a5352213e519301aa1ce161c012d08835e482b10f420d188b30804b3a3"
  license "MIT"
  version_scheme 1
  head "https:github.compyenvpyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+(-\d+)?)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7c39c8ea9596c615c33e8aab483e98c7f4b7bfa93a71e98532fad8ff9af5e4dc"
    sha256 cellar: :any,                 arm64_ventura:  "6455e40651275e47f659b86f34df83d4199e37a19c023ef75e3d5820c6cfea52"
    sha256 cellar: :any,                 arm64_monterey: "a72c900b69af7b5fdb824dccc2045c7eaf1c14b89f15935473246c8b2c7d9865"
    sha256 cellar: :any,                 sonoma:         "efe72ea550737af8723d528fbd3d0ed689caaae59f94d9a0090669c7ce65534b"
    sha256 cellar: :any,                 ventura:        "a8adc4376e624ff3af9d020a58a318ab8f588a298e8977a1631d35594f431e9d"
    sha256 cellar: :any,                 monterey:       "7e26bfaac89bf2eee07a781a34f81137334dcf6b4ab23822b57bfeca81ddce2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34e8d56b0cb3d0b8dc57f11565da4f5e362f708026248b68ddc8a4b275632021"
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