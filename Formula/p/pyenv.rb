class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://ghfast.top/https://github.com/pyenv/pyenv/archive/refs/tags/v2.8.3.tar.gz"
  sha256 "788cadf02a1eb9b1dbeaad93e472b6e4f90e550ad0d98d120b86360cf416ca1b"
  license "MIT"
  version_scheme 1
  compatibility_version 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d1146f6d91dfbfcb14a5abd240fd5f2cd30a2269c7b42f2392ce7c5ff0a054e6"
    sha256 cellar: :any, arm64_sequoia: "fb1d08648812e5971f20a8ba4f879744c444982dfb27576c67cd6816df323a13"
    sha256 cellar: :any, arm64_sonoma:  "62e3ef77932f0025d0b2f14acf32665f462c8855bacb4961635947e9a5c215bc"
    sha256 cellar: :any, tahoe:         "ecd9c0e452aa4a7eb596154fcc37250dc4ff772fdf1629af15cb93fb61a826ff"
    sha256 cellar: :any, sequoia:       "e0784c38a3a3533b4069e3fef183f4b9025750e12102bc4d2fc0ab875d944398"
    sha256 cellar: :any, sonoma:        "7053f2d5d2d40e4e8630304cf79c64aea094ce418e00a19739e33a178df79123"
    sha256 cellar: :any, arm64_linux:   "22cc9445115331a4e178687bda3678775490787f2a6576376439420106f8cd73"
    sha256 cellar: :any, x86_64_linux:  "816f26bdc450aba8047f9dbe26685e2314e141045504451c306cdc07dcdeb7d3"
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