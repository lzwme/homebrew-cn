class Libslax < Formula
  desc "Implementation of the SLAX language (an XSLT alternative)"
  homepage "https://github.com/Juniper/libslax/wiki"
  url "https://ghfast.top/https://github.com/Juniper/libslax/releases/download/3.1.5/libslax-3.1.5.tar.gz"
  sha256 "21ec2a328c23233842c625b54dc347d755eb614226ef231bd245243b9be7383c"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "e03cfaf6ff9d854e6ac7e3e7f43ca057c6a6a57a795c10db151f1ac6b47944f6"
    sha256 arm64_sonoma:  "ca76593554bb1055686d3c015b4a7568d0a37e7b85566049d840a9281f948341"
    sha256 arm64_ventura: "1ad9235389d063c10aac42a4612d1acb5ce4bc84d9146769e969a7ac1c458c67"
    sha256 sonoma:        "4858964b3586b184243e194085c882a05ba3ee7e64fee5253218e43840af7007"
    sha256 ventura:       "c5185c695ef1fa24beff9eda6016ecbc9eca42f86b555791776894dada3e49b8"
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