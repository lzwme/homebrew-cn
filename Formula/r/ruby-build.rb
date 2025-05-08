class RubyBuild < Formula
  desc "Install various Ruby versions and implementations"
  homepage "https:rbenv.orgmanruby-build.1"
  url "https:github.comrbenvruby-buildarchiverefstagsv20250507.tar.gz"
  sha256 "59992f934dccb48d2547969efd3075a5338617e02a5bff8c566ca1e51b6d349d"
  license "MIT"
  head "https:github.comrbenvruby-build.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d0ef5d0009457d4850b97d009473a98ad10155e5dd00d02994fef9939c73f452"
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