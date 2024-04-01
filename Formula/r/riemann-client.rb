class RiemannClient < Formula
  desc "C client library for the Riemann monitoring system"
  homepage "https://git.madhouse-project.org/algernon/riemann-c-client"
  url "https://git.madhouse-project.org/algernon/riemann-c-client/archive/riemann-c-client-2.2.0.tar.gz"
  sha256 "f690aea02a3652c9dc62372c4305d0b9e869cd8b7d9c22b964991a4bdf95d2be"
  license "LGPL-3.0-or-later"
  head "https://git.madhouse-project.org/algernon/riemann-c-client.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "250573eb7623272bd39a641f8425c54e25166c9d6f00536411199b3519b35d8a"
    sha256 cellar: :any,                 arm64_ventura:  "c9e0c1d3a35bfe73bc5bc680c907519f23cc10de654c6b9f1020af02133ae834"
    sha256 cellar: :any,                 arm64_monterey: "b5b3a981e301f9b3a5ff8db896bdb2052b1125a515c7cdcb4d51fd6a2af2829a"
    sha256 cellar: :any,                 sonoma:         "952af9423fa3e8d590128d983107d5d209717f835f3c27fa9e4575fafccea41f"
    sha256 cellar: :any,                 ventura:        "27ab072b295b38bebaa72d9cc080739728104df3d1daf591bfeabf6b6f118ba4"
    sha256 cellar: :any,                 monterey:       "f4a2f5ac6aaf235950f83439d477423bdcb7f0985f9bba8cc58922a4ab59cc5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08985d27aec02a506bf4aa2b6e59cfad8412d445cd8d91d59b67b87c017c406f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "json-c"
  depends_on "openssl@3"
  depends_on "protobuf-c"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--prefix=#{prefix}", "--with-tls=openssl"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/riemann-client", "send", "-h"
  end
end