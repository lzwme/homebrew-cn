class Libextractor < Formula
  desc "Library to extract meta data from files"
  homepage "https://www.gnu.org/software/libextractor/"
  url "https://ftp.gnu.org/gnu/libextractor/libextractor-1.12.tar.gz"
  mirror "https://ftpmirror.gnu.org/libextractor/libextractor-1.12.tar.gz"
  sha256 "4c87f339b482a038042498cf10af582222b577e937498cd654534e3108d5a7b1"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "c59d6276ab5571f7e5dd1be8f91d99259491b4e1c8f78493da6db5219d7cf719"
    sha256 arm64_ventura:  "e4e7b3622d255c32e0f094f95f404211f539cc49b51896777a99d86da361cd5f"
    sha256 arm64_monterey: "2356d67f6d875ef1096a750d7be42ea3d671ec71daed75b3d141d8da0d8fd436"
    sha256 sonoma:         "344450e6100bef183b0e2e1e048ca35c89d94cebe0b35a274daf97cb01e29fff"
    sha256 ventura:        "7a9736eed52e4c836a668b1c4033de1606893dd80a62bfe757ab35fa8dbd6a69"
    sha256 monterey:       "efdbc43d2215985f645b9bc87a7e41291b32988b9e933e634728d27ef570a6ae"
    sha256 x86_64_linux:   "2530119fb24ce9f027228cf1cd497e795ed43413d84ae7f4822919499f7bcd4e"
  end

  depends_on "pkg-config" => :build
  depends_on "libtool"

  uses_from_macos "zlib"

  conflicts_with "csound", because: "both install `extract` binaries"
  conflicts_with "pkcrack", because: "both install `extract` binaries"

  def install
    ENV.deparallelize

    system "./configure", "--disable-silent-rules",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    fixture = test_fixtures("test.png")
    assert_match "Keywords for file", shell_output("#{bin}/extract #{fixture}")
  end
end