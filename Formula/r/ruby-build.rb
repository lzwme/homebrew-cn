class RubyBuild < Formula
  desc "Install various Ruby versions and implementations"
  homepage "https:rbenv.orgmanruby-build.1"
  url "https:github.comrbenvruby-buildarchiverefstagsv20250326.tar.gz"
  sha256 "f028a6dbe4c9e6a95e0fa9edc8741bf76ab74a47766a99bdf3d302763f53ce2c"
  license "MIT"
  head "https:github.comrbenvruby-build.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a0a9e64a9775d06de937b30d5c4a09eb29cd30f29951686dee2bb062ac8fa309"
  end

  depends_on "autoconf"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "pkgconf"
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