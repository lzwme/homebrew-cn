class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https://github.com/warmcat/libwebsockets"
  url "https://ghfast.top/https://github.com/warmcat/libwebsockets/archive/refs/tags/v4.5.1.tar.gz"
  sha256 "c4e622facafc918efb3ce65998e458f136c5fc72f8d13900c1e3a419c1669a44"
  license "MIT"
  head "https://github.com/warmcat/libwebsockets.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "69ec136cf36706266ca71604343c9bcf080671f5cafd325b32c879a45e80aa79"
    sha256 arm64_sequoia: "4c5c01a49a77e91da98cfeee85d316c0e65cff762b8eb8d2e77d2a45082c6e3a"
    sha256 arm64_sonoma:  "2c3da95e9227e9c0705c0804b40729f0c53dbe2b2f61f9c2c1cb575b5723168b"
    sha256 sonoma:        "11f4351343d0c2af6b8809404ef5fce64b1c652b73b11684bc320e5b569258b8"
    sha256 arm64_linux:   "e0e277fc4fed7c19af29373e7924058ded9c4000831629f27aca189a8d5e418d"
    sha256 x86_64_linux:  "13c90fc67fded87628bd010da1448503d86ac799bc1b6311820b10a7572e1ffd"
  end

  depends_on "cmake" => :build
  depends_on "libevent"
  depends_on "libuv"
  depends_on "openssl@3"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DLWS_IPV6=ON",
                    "-DLWS_WITH_HTTP2=ON",
                    "-DLWS_WITH_LIBEVENT=ON",
                    "-DLWS_WITH_LIBUV=ON",
                    "-DLWS_WITH_PLUGINS=ON",
                    "-DLWS_WITHOUT_TESTAPPS=ON",
                    "-DLWS_UNIX_SOCK=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <openssl/ssl.h>
      #include <libwebsockets.h>

      int main()
      {
        struct lws_context_creation_info info;
        memset(&info, 0, sizeof(info));
        struct lws_context *context;
        context = lws_create_context(&info);
        lws_context_destroy(context);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{Formula["openssl@3"].opt_prefix}/include",
                   "-L#{lib}", "-lwebsockets", "-o", "test"
    system "./test"
  end
end