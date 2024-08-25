class RubyBuild < Formula
  desc "Install various Ruby versions and implementations"
  homepage "https:github.comrbenvruby-build"
  url "https:github.comrbenvruby-buildarchiverefstagsv20240727.tar.gz"
  sha256 "c6359deb8694e19c00af37cadef239af7e3f00e63d89e9333870bbb0178d039c"
  license "MIT"
  head "https:github.comrbenvruby-build.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "c24b8dbacb50a9ba3276fc612c94ab408042de0586aade1b12e4c315b7ff95ff"
  end

  depends_on "autoconf"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "pkg-config"
  depends_on "readline"

  def install
    # these references are (as-of v20210420) only relevant on FreeBSD but they
    # prevent having identical bottles between platforms so let's fix that.
    inreplace "binruby-build", "usrlocal", HOMEBREW_PREFIX

    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "2.0.0", shell_output("#{bin}ruby-build --definitions")
  end
end