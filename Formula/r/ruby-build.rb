class RubyBuild < Formula
  desc "Install various Ruby versions and implementations"
  homepage "https:github.comrbenvruby-build"
  url "https:github.comrbenvruby-buildarchiverefstagsv20241105.tar.gz"
  sha256 "5023c0225249b409e5936c70ae5c7cebe731566da686d6fbe3f7f5b09d6323ef"
  license "MIT"
  head "https:github.comrbenvruby-build.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "417b5c6509e39101c5c9b609292c2e8dc09710c33e0e51120218ace8368cfd65"
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