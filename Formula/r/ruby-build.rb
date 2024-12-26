class RubyBuild < Formula
  desc "Install various Ruby versions and implementations"
  homepage "https:github.comrbenvruby-build"
  url "https:github.comrbenvruby-buildarchiverefstagsv20241225.2.tar.gz"
  sha256 "ae43d89f54b8765d04673fa9da993143ac5269c1ae2671509c3d3fab73f06d20"
  license "MIT"
  head "https:github.comrbenvruby-build.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d33c0918bdce5f94ca0ae7383d23aa3a64b7e1fe7108619837d3c7dc2ba39515"
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