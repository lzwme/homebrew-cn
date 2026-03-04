class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://ghfast.top/https://github.com/pyenv/pyenv/archive/refs/tags/v2.6.25.tar.gz"
  sha256 "7e1e369c5d0ef93294002d166eb81a75e6c24792fa6dcea8be5980ead9b780a0"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6fc789662bdb8aabbf9772ac953d9c5e8125eebe5be0e04a5a14250ab4c2f771"
    sha256 cellar: :any,                 arm64_sequoia: "a1ffbac98c346824ead87c1221347e1a450d9fda39e8c9b700d89206dc3db5ca"
    sha256 cellar: :any,                 arm64_sonoma:  "501879acf0dcb1a55d37e29716f4d975a9e6aaea39f17efedece579028b7b6d9"
    sha256 cellar: :any,                 tahoe:         "48a87937048e6db9ac25b67da2f6aa319220af4881198a87684fff529db11ad4"
    sha256 cellar: :any,                 sequoia:       "f124020a0d35d5a843da500c9f6a04e536a0bce6022cdec8beca460ccd60f32b"
    sha256 cellar: :any,                 sonoma:        "5ee675bceefb6f6fcb7dce1fd425e1053f56c8c865d2f788cc0264362cd723dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e4fbbd9c351933309774265816db6d39c91e59b4b3e410f8a55317102e23451"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d44b9c4a8dba875806526e2a08d014d582a192be894769f80b7923dad55a29fe"
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

  on_linux do
    depends_on "zlib-ng-compat"
  end

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