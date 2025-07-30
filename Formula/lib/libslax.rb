class Libslax < Formula
  desc "Implementation of the SLAX language (an XSLT alternative)"
  homepage "https://github.com/Juniper/libslax/wiki"
  url "https://ghfast.top/https://github.com/Juniper/libslax/releases/download/3.1.4/libslax-3.1.4.tar.gz"
  sha256 "3e013991cbfb8b00863df322e8baaf1e4df484501ba0b0718d2a75396c9e675f"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "ab47f15613a45eb2ded488d6d4ac4dd858f2b1b81b6fd4fe2948f3b4e3b141f5"
    sha256 arm64_sonoma:  "61105e62d8e1fc30394648c292df7158905a7c51032e62224be1b0b93e1fc976"
    sha256 arm64_ventura: "b0d670ea601282e253e134ca63c111547f1759d8360e3cb32822fc2a9626de72"
    sha256 sonoma:        "edc0b2bd24fffa7d2223e6741de548439eb006e9c8415cce7cc6a5868b003994"
    sha256 ventura:       "83124c9a7e8f224ddcfb8d361d4715c995f2bcefe5eca60e34c6d2128b118409"
  end

  head do
    url "https://github.com/Juniper/libslax.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "bison" => :build
  depends_on "libtool" => :build
  depends_on :macos # needs libxslt built --with-debugger
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "libedit"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "sqlite"

  conflicts_with "genometools", because: "both install `bin/gt`"
  conflicts_with "libxi", because: "both install `libxi.a`"

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--disable-silent-rules", "--enable-libedit", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"hello.slax").write <<~EOS
      version 1.0;

      match / {
          expr "Hello World!";
      }
    EOS

    system bin/"slaxproc", "--slax-to-xslt", "hello.slax", "hello.xslt"
    assert_path_exists testpath/"hello.xslt"
    assert_match "<xsl:text>Hello World!</xsl:text>", File.read("hello.xslt")
  end
end