class X3270 < Formula
  desc "IBM 3270 terminal emulator for the X Window System and Windows"
  homepage "https://x3270.bgp.nu/"
  url "http://x3270.bgp.nu/download/04.03/suite3270-4.3ga9-src.tgz"
  sha256 "6404d27b29a40d896daab35ff153cab157d85094b38bdeb4ebaaaf2673ce4db1"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url "https://x3270.miraheze.org/wiki/Downloads"
    regex(/href=.*?suite3270[._-]v?(\d+(?:\.\d+)+(?:ga\d+)?)(?:-src)?\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "0725784134da0c9564ae116b52664de68d9c75e9cf5768b418433ed8cf70c0da"
    sha256 arm64_sonoma:  "137040aa21e9886c430ba38359497c1dca16b586d78647dbe4f31ba84c100dea"
    sha256 arm64_ventura: "955a63b7239ed7a6a9682c91021ff2b655a45894740fd1b77fb32ac3ca207ee5"
    sha256 sonoma:        "d32203222eaf6eb19139bcbd717bee3d4490da036878ebfa733ac6f29ed6cd9d"
    sha256 ventura:       "d11a8334691d3d3b974e697c82bcd7afc3e880ef34d1b8edababea80e86c0f07"
    sha256 x86_64_linux:  "920b8aa544fd833e7558f755776e1ded14bf9e28c9aa278412e263c267254815"
  end

  depends_on "openssl@3"
  depends_on "readline"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "tcl-tk@8"
  end

  def install
    ENV.append "CPPFLAGS", "-I#{Formula["tcl-tk@8"].opt_include}/tcl-tk" if OS.linux?

    args = %w[
      --enable-c3270
      --enable-pr3287
      --enable-s3270
      --enable-tcl3270
    ]
    system "./configure", *args, *std_configure_args
    system "make", "install"
    system "make", "install.man"
  end

  test do
    system bin/"c3270", "--version"
  end
end