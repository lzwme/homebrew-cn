class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://ghfast.top/https://github.com/pyenv/pyenv/archive/refs/tags/v2.6.22.tar.gz"
  sha256 "66975e87cec083610ab642b649be56dfd36cd347b7f60b8a36e395bc9082c587"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "e3bcebfd9fee8a41c5574515065902fac8267c803d65d5400d1d110a50739607"
    sha256 cellar: :any,                 arm64_sequoia: "82c474ad7d40b7afacca655930d5b1f59134a72ce7a34490d2b61fa77e45746e"
    sha256 cellar: :any,                 arm64_sonoma:  "7ca551d4df3face147f97cf6c6658c0105fcca731f19ce6cb05fa2e7fe748e87"
    sha256 cellar: :any,                 tahoe:         "3a64fa36d56eb80941b35b3d68ca18f615d27093513aa188adb26ee1a29bfb1c"
    sha256 cellar: :any,                 sequoia:       "389582b57ba7630c9a7c87f76a787c8edea427b9059a8637404fcda12c70729d"
    sha256 cellar: :any,                 sonoma:        "866249cfb18588223683ad3ec18c6a76d70f66cefb1e9662a1edf0ef3d27d2ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40378033fa107a2309f0becd378ebfbce56be066cd3a0dff55d67e8069367415"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55443c7120aa91792281e39599914ee9554f95341e9890b4416bdc447d324b90"
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