class Whois < Formula
  desc "Lookup tool for domain names and other internet resources"
  homepage "https://github.com/rfc1036/whois"
  url "https://ghfast.top/https://github.com/rfc1036/whois/archive/refs/tags/v5.6.3.tar.gz"
  sha256 "5bdaf291465ef185384d9b5c4482f377a8040c008433b51d3cb8a4627f7aab14"
  license "GPL-2.0-or-later"
  head "https://github.com/rfc1036/whois.git", branch: "next"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "79bc7ee8d13e233bf2c0ef7816d0ed2827b41a3e6c85ee21ec0eca8cc0b1b82f"
    sha256 cellar: :any,                 arm64_sonoma:  "35fadb940b2dd257004747b51e08498f3139114e3ac962f75d599f00f67d2b90"
    sha256 cellar: :any,                 arm64_ventura: "6c455212cf834f68f8ffd302adb9749e6afac6c2fe47c49daa17089154a200e0"
    sha256 cellar: :any,                 sonoma:        "87305e85c2556cbe55957d7da430f56fdfeed7d40e5d5ac8a9208869be51a4df"
    sha256 cellar: :any,                 ventura:       "c3e2c6c63e161ea6193de0999aa8935dcbf4ff7d75b308a205dbd266f81a8871"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9beb3e0f57be3f71e81942236c7cdf6f2c13983b7f1c88ab5d2d40febeafe96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75584d231d37a8b730bdae459bc63cff0c1164d12d9506dc25b07eccf000a1e2"
  end

  keg_only :provided_by_macos

  depends_on "pkgconf" => :build
  depends_on "libidn2"

  def install
    ENV.append "LDFLAGS", "-L/usr/lib -liconv" if OS.mac?

    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    have_iconv = if OS.mac?
      "HAVE_ICONV=1"
    else
      "HAVE_ICONV=0"
    end

    system "make", "install-whois", "prefix=#{prefix}", have_iconv
  end

  test do
    system bin/"whois", "brew.sh"
  end
end