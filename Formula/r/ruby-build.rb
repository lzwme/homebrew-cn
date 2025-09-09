class RubyBuild < Formula
  desc "Install various Ruby versions and implementations"
  homepage "https://rbenv.org/man/ruby-build.1"
  url "https://ghfast.top/https://github.com/rbenv/ruby-build/archive/refs/tags/v20250908.tar.gz"
  sha256 "057167bb7507be05f75449bc9b7531f68420de2b1347f5a50b99a0fc07bb197c"
  license "MIT"
  head "https://github.com/rbenv/ruby-build.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, all: "af5497a48c17b80dcf50ed61aa6ce9fc0b034da164958b02e851c22a3b291360"
  end

  depends_on "autoconf"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "pkgconf"
  depends_on "readline"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "2.0.0", shell_output("#{bin}/ruby-build --definitions")
  end
end