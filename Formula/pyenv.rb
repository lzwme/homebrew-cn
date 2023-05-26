class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://ghproxy.com/https://github.com/pyenv/pyenv/archive/refs/tags/v2.3.18.tar.gz"
  sha256 "7feacbadc3fadf4ac47f1085936dfa870f9f3b3dff6cee4280e50d64d1425f9b"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "659ffa9fa46516ba3ffedb96484e0d33d371a91b14ad00b3f9b9b94f6bbf4fc3"
    sha256 cellar: :any,                 arm64_monterey: "371d72697ce0c68f5ea865c7b17d1ddcff4aa0bb75844dda102320953330d76f"
    sha256 cellar: :any,                 arm64_big_sur:  "996a053fa496c54671971f1fc0eb58bd82c80e0d7a4adeac4103169957225d94"
    sha256 cellar: :any,                 ventura:        "6438076f5b654b76e4de7311bc17665b60d44ae8962430664828e1bda069d6bc"
    sha256 cellar: :any,                 monterey:       "52c7649f88a56c9cc44ea1aa4a52423f17b40b70584c96931eb93a4e186bc883"
    sha256 cellar: :any,                 big_sur:        "f5f58b960835c4e63151d2c4638f6f94d49fdd06fa83c492a5cdc7dbc426a810"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e740adde8fc8fcc7557ab0ae8f4b9f0a56faa6f3577d06f0615fb2b5c321bb40"
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
    inreplace "libexec/pyenv", "/usr/local", HOMEBREW_PREFIX
    inreplace "libexec/pyenv-rehash", "$(command -v pyenv)", opt_bin/"pyenv"
    inreplace "pyenv.d/rehash/source.bash", "$(command -v pyenv)", opt_bin/"pyenv"

    system "src/configure"
    system "make", "-C", "src"

    prefix.install Dir["*"]
    %w[pyenv-install pyenv-uninstall python-build].each do |cmd|
      bin.install_symlink "#{prefix}/plugins/python-build/bin/#{cmd}"
    end

    share.install prefix/"man"

    # Do not manually install shell completions. See:
    #   - https://github.com/pyenv/pyenv/issues/1056#issuecomment-356818337
    #   - https://github.com/Homebrew/homebrew-core/pull/22727
  end

  test do
    # Create a fake python version and executable.
    pyenv_root = Pathname(shell_output("#{bin}/pyenv root").strip)
    python_bin = pyenv_root/"versions/1.2.3/bin"
    foo_script = python_bin/"foo"
    foo_script.write "echo hello"
    chmod "+x", foo_script

    # Test versions.
    versions = shell_output("eval \"$(#{bin}/pyenv init --path)\" " \
                            "&& eval \"$(#{bin}/pyenv init -)\" " \
                            "&& #{bin}/pyenv versions").split("\n")
    assert_equal 2, versions.length
    assert_match(/\* system/, versions[0])
    assert_equal("  1.2.3", versions[1])

    # Test rehash.
    system bin/"pyenv", "rehash"
    refute_match "Cellar", (pyenv_root/"shims/foo").read
    assert_equal "hello", shell_output("eval \"$(#{bin}/pyenv init --path)\" " \
                                       "&& eval \"$(#{bin}/pyenv init -)\" " \
                                       "&& PYENV_VERSION='1.2.3' foo").chomp
  end
end