class RubyBuild < Formula
  desc "Install various Ruby versions and implementations"
  homepage "https:rbenv.orgmanruby-build.1"
  url "https:github.comrbenvruby-buildarchiverefstagsv20250415.tar.gz"
  sha256 "57e8b37c70b67b9e746640e4b5fc171f07d11fe3fae2b80fd17207b05d8a030a"
  license "MIT"
  head "https:github.comrbenvruby-build.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7f445b9ae1bc516e49fc620409e62de696f975169522418bf306180b81ea7bba"
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