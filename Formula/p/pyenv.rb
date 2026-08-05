class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://ghfast.top/https://github.com/pyenv/pyenv/archive/refs/tags/v2.8.2.tar.gz"
  sha256 "e78fc39538e416a85b23bef5003aefd9d9a786b4e62cdb7911f221aa2b769276"
  license "MIT"
  version_scheme 1
  compatibility_version 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "85f1a1c6d3bae58d92cc9b93936d92b82bc5d3a3d4927978b0d09fc60ab45efe"
    sha256 cellar: :any, arm64_sequoia: "baff346b6be7ebebc1f6d728440712619aae13d002c942ee814c796fc71cb106"
    sha256 cellar: :any, arm64_sonoma:  "72e4805cc47b12284915b01081ac0e091ad7eea9515a8a5680c1bd72d3e31cec"
    sha256 cellar: :any, tahoe:         "5097ccdcd76e01adcd461666875728de6262e4b208a27ffba3c7fd814d068a7c"
    sha256 cellar: :any, sequoia:       "1960f0e794b9c365fca6169772a1b04ba3610d95acfa28bea8abb8c4bb06d63a"
    sha256 cellar: :any, sonoma:        "c49f5d963c07b7a31fc4622eb82ba84272682d7f809236486a6eb425ea8dc167"
    sha256 cellar: :any, arm64_linux:   "c0118c09dba91b289854a029fb2b4c498790bcc5b7af23b09c3cdd58965971b0"
    sha256 cellar: :any, x86_64_linux:  "c0f1f2acfbe0106c5ada0c77ab475259f66840c0c7bc99e2de36aa7dcc41f715"
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