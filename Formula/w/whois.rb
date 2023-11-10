class Whois < Formula
  desc "Lookup tool for domain names and other internet resources"
  homepage "https://github.com/rfc1036/whois"
  url "https://ghproxy.com/https://github.com/rfc1036/whois/archive/refs/tags/v5.5.20.tar.gz"
  sha256 "c15d527cad54a9d681415840060581b9d349e017b582fd575ee0f3133a1deef4"
  license "GPL-2.0-or-later"
  head "https://github.com/rfc1036/whois.git", branch: "next"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5ae075200cf83e0b4e4079ba25d80051a6206d97ded82ed348b438cdb109444c"
    sha256 cellar: :any,                 arm64_ventura:  "9c24eb0782ae6d0a6286ee94eedf0ffe984c470fc954411d5772ca5107e80b1a"
    sha256 cellar: :any,                 arm64_monterey: "91ae663c07442b41c71e845e34f42c5f4679526249408ec383ca361ae96053c4"
    sha256 cellar: :any,                 sonoma:         "188313e1df8f8de939e14933e09260ae7a0fc911ea02d46fcdc65d33d901f1b7"
    sha256 cellar: :any,                 ventura:        "d7c1533fbbc24c5384f4b0e0021b39fc5d23b8350b9b68daf6e8972a7f94f207"
    sha256 cellar: :any,                 monterey:       "621fea4f1cf7fbd926b2a9cbcc66da53c0005961230dcda944bba6f16e33fc6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3d8639251359cf55a78bb837f5155210b2c9995f295a9d834c2d486b7262a33"
  end

  keg_only :provided_by_macos

  depends_on "pkg-config" => :build
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

    system "make", "whois", have_iconv
    bin.install "whois"
    man1.install "whois.1"
    man5.install "whois.conf.5"
  end

  test do
    system "#{bin}/whois", "brew.sh"
  end
end