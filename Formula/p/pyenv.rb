class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://ghfast.top/https://github.com/pyenv/pyenv/archive/refs/tags/v2.6.5.tar.gz"
  sha256 "ebf75a81125d8fb9b5d6930821a0e08200a414c029c93fd27aaa9a519ef1b546"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "15b719a5114c5834dc546484cdd6ad6625ffa3e18e3712ec441442e82644973c"
    sha256 cellar: :any,                 arm64_sonoma:  "c8d15f9c41af34f269b15f439675d5bf11e713ff56bd7f422bbdb0b0fa757386"
    sha256 cellar: :any,                 arm64_ventura: "f6f70daf56030cd1ec6486043d312198e1b4946827930a64c67a203e934fa848"
    sha256 cellar: :any,                 sonoma:        "e9fb3f0de9055d54f065f0b686f9ad0866a4754b32a682e58c4af4d6b37ba84b"
    sha256 cellar: :any,                 ventura:       "5e62ac8275be78cd04277bbccf84b7d6c478407d5e6083b98bad7af8c079b22a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2671ab31e92fdceb9c321cd8294c703f3152388cd4013c5c09142cdbb21bbc23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc54d8469b93af20fab47f68363cbfa5d869a8b2167f3c43f18128596b8ef74c"
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