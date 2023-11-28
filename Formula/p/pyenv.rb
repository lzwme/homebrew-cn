class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://ghproxy.com/https://github.com/pyenv/pyenv/archive/refs/tags/v2.3.33.tar.gz"
  sha256 "27e53c2e4082488d14d39749e9345f939fcd9171a100f76e1d940b5225fa8ff0"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5735333c59011f9921ac3f6cf46dce8bded61ec5c4bc08d2b367d704e3c40f61"
    sha256 cellar: :any,                 arm64_ventura:  "be51781e18da7f3a560b349337893b5a4d52c7139ec21a6b765a665eee8ed444"
    sha256 cellar: :any,                 arm64_monterey: "dfebf51d5b2f46608af99066aa4ebc88bdb974d68e2938d983f5cfc3bcd47dd3"
    sha256 cellar: :any,                 sonoma:         "5ccdf674ffac3fd46d9442eefa8dacfd3ce714de2fe5fe5e9b2959677c22a9da"
    sha256 cellar: :any,                 ventura:        "77353eb9317d8a9b1071c1f6a5348b3293cfdd852784cf1819a95b4bdde55dbe"
    sha256 cellar: :any,                 monterey:       "b539bd294bffc5332d020222a4eb46f4d14b7cfd34cdbcf175b2d3555879b058"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50e82dfddfe74b85bd48ba090d44b7c574bd5413e93ebb1eaf570e072a0bb321"
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