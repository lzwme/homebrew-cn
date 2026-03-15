class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https://github.com/warmcat/libwebsockets"
  url "https://ghfast.top/https://github.com/warmcat/libwebsockets/archive/refs/tags/v4.5.5.tar.gz"
  sha256 "150ff2ff3222d94c141ad0dd2fe3b9daeae14afc460a536db2fd3137a0a381a3"
  license "MIT"
  compatibility_version 3
  head "https://github.com/warmcat/libwebsockets.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "1af6978cbcd66694d962fc9316e5652c9339304343d22a481699ea1c2e5955d0"
    sha256 arm64_sequoia: "812c749415fb06cee442e5f5b9c3dcb73a479699ca97ea6cfbe33c1181957530"
    sha256 arm64_sonoma:  "226be163e74aaa181cdb51fc61afd241c84b0c49e61457c77cdbe9c9be8c3b66"
    sha256 sonoma:        "7d6cc4088834743697337b8748c1ce5dc58180846821ee633c9521125311bb37"
    sha256 arm64_linux:   "918148e2c41b20f672c83f8bd615f8ebbb2ab90ca640746ee47f363c79a4d8f0"
    sha256 x86_64_linux:  "1ef0c0eff8a6bcbbcb219cdba2ab0790a2bb63463fc3df25e92dd65cd2a412f0"
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