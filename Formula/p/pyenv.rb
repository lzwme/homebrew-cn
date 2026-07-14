class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://ghfast.top/https://github.com/pyenv/pyenv/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "0773be07e7276f71496c387874ebeb780f8593468546a511bda7750da80c7d8a"
  license "MIT"
  version_scheme 1
  compatibility_version 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "43656dad480ef2022559819b52e8ca9a31efea0ecb826ed5da3a08a24a9c598b"
    sha256 cellar: :any, arm64_sequoia: "68fd3ea9522302a85072833e6e826afc9e9e74c7eecc8ff0b7fc2aff1c12a2e6"
    sha256 cellar: :any, arm64_sonoma:  "7639c0582f7e6b8189bf598ddbe773df6b23946980846609f6135525242e3209"
    sha256 cellar: :any, tahoe:         "82979c7068a275275c825d5359dd8e0a1e09c745ef2042dbecff3605141acb99"
    sha256 cellar: :any, sequoia:       "8162357297e2cb37f2daadeb8bccd28b0987b6547f6aaf23aeb898a7289502a5"
    sha256 cellar: :any, sonoma:        "1695b8322cbdd5dd2e303a00cba7cc6cdd341650d895958695abc7bac14ac22f"
    sha256 cellar: :any, arm64_linux:   "064419e68c86033b10977314eba231961958c8333d7045f4222fda84e0410f59"
    sha256 cellar: :any, x86_64_linux:  "9920d1c6325be57c70499155ce4bc246287b6b53dd7e464b64aea06c1f17bd61"
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