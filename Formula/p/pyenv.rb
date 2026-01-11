class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://ghfast.top/https://github.com/pyenv/pyenv/archive/refs/tags/v2.6.18.tar.gz"
  sha256 "db0ce74a5a6e2b63d80788823802d9437bacf15ef297dea73efa1516af3365e9"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "31953d4cea89fd8d1d4d8b4e8b3b95752944e383e19e34731ce7202070d2d3b7"
    sha256 cellar: :any,                 arm64_sequoia: "db9e66a422b84461931dc79275af2e6ad29de2e5dedb0ae7b76a282cccb3c655"
    sha256 cellar: :any,                 arm64_sonoma:  "d13e52adeee3198f6620dfb6b82bef02f650e18bd9a76200854111a190f95c15"
    sha256 cellar: :any,                 sonoma:        "3f2b10d96cf8482dd2da6cf6c8554e7b0ed7435f2f7b640aa5bef023ea7c5da4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "509a1d6495ee85c63fa6692d6fe87ea380fa69ffd95cf2af39c3ffa25fbadc8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d56db38d9e91292779a36156d550e18b57a48dfc5cead9500f86a43e8f2aabab"
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