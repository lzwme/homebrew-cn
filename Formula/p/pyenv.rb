class Pyenv < Formula
  desc "Python version management"
  homepage "https:github.compyenvpyenv"
  url "https:github.compyenvpyenvarchiverefstagsv2.4.4.tar.gz"
  sha256 "8e3e916ac8bcfa534ef91c1abb364a0c7814d03d20e4b84227d3f78077163d86"
  license "MIT"
  version_scheme 1
  head "https:github.compyenvpyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+(-\d+)?)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2d8c8894ce1d3424570df0e436c118594aaee71c896ada1fad397f6d8f625112"
    sha256 cellar: :any,                 arm64_ventura:  "5cdcd1b50cdd73fbff08706d444077bc035707d9aea01b11a2286c74d4204a1b"
    sha256 cellar: :any,                 arm64_monterey: "011204cf3d21375f91bfbd8741353b0f4f992a5e738c46f26687aae9691af28b"
    sha256 cellar: :any,                 sonoma:         "f241903ea3781b365407d283ef8cfba026a69b7baa66127eaee330e0558e1c66"
    sha256 cellar: :any,                 ventura:        "c90d0b3fa866159dbb0dea8ef7c289b69c6958259cfee8fea2ee3aea1124e9c7"
    sha256 cellar: :any,                 monterey:       "b4cde957c28476f073bb9b410babd79276e36f3f8a628327d20398159f9cadd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d74a1321f400816eb5525d6aee49c48891b1ad6cb6640be60b19157f8be9557a"
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