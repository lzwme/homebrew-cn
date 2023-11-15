class RubyBuild < Formula
  desc "Install various Ruby versions and implementations"
  homepage "https://github.com/rbenv/ruby-build"
  url "https://ghproxy.com/https://github.com/rbenv/ruby-build/archive/refs/tags/v20231114.tar.gz"
  sha256 "0ecb3c870ec260b6b80a462bdba423768dee3247e4422e4be92ad5790ac41104"
  license "MIT"
  head "https://github.com/rbenv/ruby-build.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "44e02d92cc0c99db3acdb5753972a446af0a426f34ce426295d22ba9902058b1"
  end

  depends_on "autoconf"
  depends_on "libyaml"
  depends_on "pkg-config"
  depends_on "readline"
  on_macos do
    depends_on "openssl@3"
  end

  def install
    # these references are (as-of v20210420) only relevant on FreeBSD but they
    # prevent having identical bottles between platforms so let's fix that.
    inreplace "bin/ruby-build", "/usr/local", HOMEBREW_PREFIX

    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "2.0.0", shell_output("#{bin}/ruby-build --definitions")
  end
end