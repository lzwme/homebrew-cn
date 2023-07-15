class Libnghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://ghproxy.com/https://github.com/nghttp2/nghttp2/releases/download/v1.55.0/nghttp2-1.55.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/nghttp2-1.55.0.tar.gz"
  # this legacy mirror is for user to install from the source when https not working for them
  # see discussions in here, https://github.com/Homebrew/homebrew-core/pull/133078#discussion_r1221941917
  mirror "http://fresh-center.net/linux/www/legacy/nghttp2-1.55.0.tar.gz"
  sha256 "1e2d802c19041bc16c1bcc48d13858beb39f4ea64c0dfe3f04bfac6de970329d"
  license "MIT"

  livecheck do
    formula "nghttp2"
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0b951dd0e759a2c34b650d233782f635b2eb09726252c0871f7bea1aa948a296"
    sha256 cellar: :any,                 arm64_monterey: "07faea1d9427138272deedb9dd2dca8e475688723dbf8dae046f94337050e263"
    sha256 cellar: :any,                 arm64_big_sur:  "ac4e5d7854960776bfb063868e72413ce81f6f45188a7c67c76f7eef56867a8c"
    sha256 cellar: :any,                 ventura:        "fbe9bbf0133bcc67905ea1cf34398e10c52a3b8ac33febd9525738bec17897d9"
    sha256 cellar: :any,                 monterey:       "8b084a745cf8b2f61c90b8202958be836a2d8059b0395ff8fccaeee730f7708b"
    sha256 cellar: :any,                 big_sur:        "98f76ead2796a7a8cb1f212d1dc5b311b89163c1fdd3746218648e492fccf8e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c3d5aeb060b9edeb1e7ef5cc61cf60c6eee26d951598be73d1da82a8e7bc20c"
  end

  head do
    url "https://github.com/nghttp2/nghttp2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build

  # These used to live in `nghttp2`.
  link_overwrite "include/nghttp2"
  link_overwrite "lib/libnghttp2.a"
  link_overwrite "lib/libnghttp2.dylib"
  link_overwrite "lib/libnghttp2.14.dylib"
  link_overwrite "lib/libnghttp2.so"
  link_overwrite "lib/libnghttp2.so.14"
  link_overwrite "lib/pkgconfig/libnghttp2.pc"

  def install
    system "autoreconf", "-ivf" if build.head?
    system "./configure", *std_configure_args, "--enable-lib-only"
    system "make", "-C", "lib"
    system "make", "-C", "lib", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <nghttp2/nghttp2.h>
      #include <stdio.h>

      int main() {
        nghttp2_info *info = nghttp2_version(0);
        printf("%s", info->version_str);
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lnghttp2", "-o", "test"
    assert_equal version.to_s, shell_output("./test")
  end
end