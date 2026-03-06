class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https://github.com/warmcat/libwebsockets"
  url "https://ghfast.top/https://github.com/warmcat/libwebsockets/archive/refs/tags/v4.5.4.tar.gz"
  sha256 "f2aa31a0be16d45470360b868f3b5b114990da038ba5e49569f0732c58b2d9fc"
  license "MIT"
  compatibility_version 2
  head "https://github.com/warmcat/libwebsockets.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "d9d43d42a69dac6d47cbe617823541a493204cea01c95c6988672fb7ef54a121"
    sha256 arm64_sequoia: "0935eeb7dda7941826f3ab857e247b53cf66130f10c6a5910fa6dbcf235f555e"
    sha256 arm64_sonoma:  "6932a8a409330c9bc4db13b2b50826b9e6619f2bfd2c0f08a8953277ce9ef0a3"
    sha256 sonoma:        "bd18b625a62b637f6c21b71937a8e1ddb26e7bd2d9150fde24496db5c691f7e7"
    sha256 arm64_linux:   "8a76cdb1930e82ce621d59813b605cc5ccaba8a13deb98f3731f9fd07eca053b"
    sha256 x86_64_linux:  "072945865ba3253ef8c17fea3a921e17a2704613f4bc641f445cc6d81db3f64c"
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