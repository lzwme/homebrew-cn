class X3270 < Formula
  desc "IBM 3270 terminal emulator for the X Window System and Windows"
  homepage "http://x3270.bgp.nu/"
  url "http://x3270.bgp.nu/download/04.03/suite3270-4.3ga3-src.tgz"
  sha256 "44d73c2614e5aa022bf16a1c8cceda2326e4c96a892da42f256ee4e13bc3a85d"
  license "BSD-3-Clause"

  livecheck do
    url "https://x3270.miraheze.org/wiki/Downloads"
    regex(/href=.*?suite3270[._-]v?(\d+(?:\.\d+)+(?:ga\d+)?)(?:-src)?\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "83d2091625fb43f6ab4406da20bd75a6efca3ebc78f733f29a5c0e83597674d1"
    sha256 arm64_ventura:  "c69a0b2303cbe9670f4b9145919157676263ed73b2093f5ac49850de9976f424"
    sha256 arm64_monterey: "d3dd0d6757c05c454fa79baee27731c00b3de4e12f2b673708ab4e131607cba0"
    sha256 sonoma:         "2c77fe6c78cd2e69772b74bdb191c78699b424c6c079eb71a3f4fe55d234a19f"
    sha256 ventura:        "0e404fd6314a2af4c806e6deff14cde53c2d99e057142c1449e3f12ba0e45675"
    sha256 monterey:       "c253dd3723216bf5e05615fd27941f991d663438b14d50acf6814d074373f128"
    sha256 x86_64_linux:   "f27c0348dd39bb5987937b7b606b963569e9b160b89d228aee477edf725f64f6"
  end

  depends_on "openssl@3"
  depends_on "readline"

  uses_from_macos "tcl-tk"

  def install
    ENV.append "CPPFLAGS", "-I#{Formula["tcl-tk"].opt_include}/tcl-tk" unless OS.mac?

    args = %w[
      --enable-c3270
      --enable-pr3287
      --enable-s3270
      --enable-tcl3270
    ]
    system "./configure", *std_configure_args, *args
    system "make", "install"
    system "make", "install.man"
  end

  test do
    system bin/"c3270", "--version"
  end
end