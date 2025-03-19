class RubyBuild < Formula
  desc "Install various Ruby versions and implementations"
  homepage "https:rbenv.orgmanruby-build.1"
  url "https:github.comrbenvruby-buildarchiverefstagsv20250318.tar.gz"
  sha256 "71dae9b458cfbf35a4257c89b088d49f7f73034c5a080ca7fd5040392b6674fa"
  license "MIT"
  head "https:github.comrbenvruby-build.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e9dde402265ab83d57775e21fa57cb285fb04b8f4ec33fdffed44e38b13574da"
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