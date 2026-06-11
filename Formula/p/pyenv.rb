class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://ghfast.top/https://github.com/pyenv/pyenv/archive/refs/tags/v2.7.2.tar.gz"
  sha256 "06b1953386c06594260a1c3d92a6d7625acc710bb10198de313a8ea7035e43f6"
  license "MIT"
  version_scheme 1
  compatibility_version 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9b251895ed21221791ed3ababfa83bb249077f2284361dee949bd0dd06412bf1"
    sha256 cellar: :any, arm64_sequoia: "16f2b8ae30a1e863b04b4228497eddd18867e7702442e508dd5815842982c859"
    sha256 cellar: :any, arm64_sonoma:  "65f82781683de1de733203ab63e0553772d1cf1ac9389bde07791bf6fffdb3f2"
    sha256 cellar: :any, tahoe:         "1afb91912f0c5581b84a254085d5f9deef269119770d6d7d6a93f37010d5d4c4"
    sha256 cellar: :any, sequoia:       "c170bfbb634c7765b14f144537949ab466e79682651af14c6d19dd8134b97321"
    sha256 cellar: :any, sonoma:        "43f755d26f75f5b8cfe2e95aa7309f354f92a9593524572579e4417a9bc88402"
    sha256 cellar: :any, arm64_linux:   "1b9d4c3600f1e39eac61b99631b6464073f4818b74f06228e3cee2421849231e"
    sha256 cellar: :any, x86_64_linux:  "6dfbf47a568e8245f2b33747cdc65f423a54d39413e35c5491405bb823d9ed25"
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