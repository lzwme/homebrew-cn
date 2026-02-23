class RubyBuild < Formula
  desc "Install various Ruby versions and implementations"
  homepage "https://rbenv.org/man/ruby-build.1"
  url "https://ghfast.top/https://github.com/rbenv/ruby-build/archive/refs/tags/v20260222.tar.gz"
  sha256 "d9e300fc523d63ed13461279340c647c4cd0d5948362a27ffb95de7d1e29d271"
  license "MIT"
  head "https://github.com/rbenv/ruby-build.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1439c86201020faee7c5252630489ddbc4acc2b1c57b0534eb14782a96ff591b"
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