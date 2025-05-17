class RubyBuild < Formula
  desc "Install various Ruby versions and implementations"
  homepage "https:rbenv.orgmanruby-build.1"
  url "https:github.comrbenvruby-buildarchiverefstagsv20250516.tar.gz"
  sha256 "16b3778d6a8ab04dec53078bedb728d87dec97727b9e88c0acd8194a9728c269"
  license "MIT"
  head "https:github.comrbenvruby-build.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fdb0caa3f40aa2f6afcb20c7cf18f67b6ec48b172f2cc3adfbcb09e8e3866af9"
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