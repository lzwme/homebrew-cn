class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://ghfast.top/https://github.com/pyenv/pyenv/archive/refs/tags/v2.6.28.tar.gz"
  sha256 "20f0c8a22f222540d11913ac4e22ef127a694a65fbb8baeb5dd82fefa10851d2"
  license "MIT"
  version_scheme 1
  compatibility_version 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "85760f3823384e7f1f1a517cffabd6d2bdb105d34f803b11a07a6458ef054433"
    sha256 cellar: :any,                 arm64_sequoia: "86585ef044b60d8a9610eabca7cbf3e117313ba8954648bf76fdad68d36d2e8a"
    sha256 cellar: :any,                 arm64_sonoma:  "c79671969e0555377b0f6be74fef9cfc8052dfee15b3792c02fce9bb9f64436c"
    sha256 cellar: :any,                 tahoe:         "a342e30bf12fe87c13490fd487166941c14b9eb65e6b05e0756d8eae6d4c426d"
    sha256 cellar: :any,                 sequoia:       "e97c1fb6bdb9c6b356e5429a38fc6714a022f8ee303c09537df135e397ccc724"
    sha256 cellar: :any,                 sonoma:        "de52e7a75fff08a81a0821c47ac539c1a382b346fd994a0968cdf37cc9cb8243"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0bddd588425b0cd941a7982ca5d1068a8d127f8abe702ebeed8edb3d0242f57c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec6b74abdabad3af25f05692121c88476a13732fbd9b7c039111fc0fd0423b9b"
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