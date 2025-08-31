class RubyBuild < Formula
  desc "Install various Ruby versions and implementations"
  homepage "https://rbenv.org/man/ruby-build.1"
  url "https://ghfast.top/https://github.com/rbenv/ruby-build/archive/refs/tags/v20250829.tar.gz"
  sha256 "8dafe0a69151592385c7114023e6cf5423022479f9054435df2d19ed6b42bff7"
  license "MIT"
  head "https://github.com/rbenv/ruby-build.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fdc15aef39d5db7e92e71e24167966c9b41482dd4fcf852e10062231cb7343d1"
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