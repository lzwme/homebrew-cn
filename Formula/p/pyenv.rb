class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://ghproxy.com/https://github.com/pyenv/pyenv/archive/refs/tags/v2.3.32.tar.gz"
  sha256 "97f6568977b0ba867de9dc08ba6ce8a2e42134ec7fa718df883a983cb9901844"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "101c074ecb847bb8754e10d54b8ccd83575b620ceced2ee337a43022e9ea1f06"
    sha256 cellar: :any,                 arm64_ventura:  "e0b5404021420b5ae1f09929a3bcdc9e6d544fdade1d98c60eeb53f182db6b0d"
    sha256 cellar: :any,                 arm64_monterey: "02bd0bc26f3d1238506c88a463863b40993ae6d465db1f10890d6662947d9f68"
    sha256 cellar: :any,                 sonoma:         "50044b2103632236c9fb9c1a4ab7889d7dfcbeb5e8f069701cf324af980e70f9"
    sha256 cellar: :any,                 ventura:        "02f61f67742a4986ef14394d62075bd534258ffa9b86f31a8508b2148ea58260"
    sha256 cellar: :any,                 monterey:       "6eb2c9b9ee24692704fd1384ffe3bbc280cdbcbb6b65d693f92fa535d37658cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e90a526d61299ecfd5577fbfd718fe93ff4b4a1c80833c65b884f8b7737e87e"
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