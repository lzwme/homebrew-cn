class RubyBuild < Formula
  desc "Install various Ruby versions and implementations"
  homepage "https://github.com/rbenv/ruby-build"
  url "https://ghproxy.com/https://github.com/rbenv/ruby-build/archive/v20230615.tar.gz"
  sha256 "92a00671ecf388cb0c5cde3e8eca126314d1c07ab087a510bf0e4bd5755e18fa"
  license "MIT"
  head "https://github.com/rbenv/ruby-build.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5f2c2124eba607349b2d9d11731e8a3c54fceda115de1885b18d6c588093ab6c"
  end

  depends_on "autoconf"
  depends_on "libyaml"
  depends_on "pkg-config"
  depends_on "readline"

  def install
    # these references are (as-of v20210420) only relevant on FreeBSD but they
    # prevent having identical bottles between platforms so let's fix that.
    inreplace "bin/ruby-build", "/usr/local", HOMEBREW_PREFIX

    ENV["PREFIX"] = prefix
    system "./install.sh"
  end

  def caveats
    <<~EOS
      ruby-build installs a non-Homebrew OpenSSL for each Ruby version installed and these are never upgraded.

      To link Rubies to Homebrew's OpenSSL 1.1 (which is upgraded) add the following
      to your shell profile e.g. ~/.profile or ~/.zshrc:
        export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"

      Note: this may interfere with building old versions of Ruby (e.g <2.4) that use
      OpenSSL <1.1.
    EOS
  end

  test do
    assert_match "2.0.0", shell_output("#{bin}/ruby-build --definitions")
  end
end