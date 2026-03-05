class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https://github.com/warmcat/libwebsockets"
  url "https://ghfast.top/https://github.com/warmcat/libwebsockets/archive/refs/tags/v4.5.3.tar.gz"
  sha256 "af8f67cf00dc31ac49e0a8404d7be68cbd44292d93c176a8b2ba9de2912da745"
  license "MIT"
  compatibility_version 1
  head "https://github.com/warmcat/libwebsockets.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "3bef0f097aae33f2012b6743c1541339180511fa4775b411de147c16e8eb09e3"
    sha256 arm64_sequoia: "f074f309cfbd75217310138c9c9a5fed8af2207e529b9a03a37d0189a7087207"
    sha256 arm64_sonoma:  "9eb0d0c1e5ad8637423ad65648d097fd969c2ee8ab9092480f86a3ea0bd19a0b"
    sha256 sonoma:        "bcd7587215586e31302fcdbdd86be1a75f42def1ca6a3c646006d06b24d830ae"
    sha256 arm64_linux:   "647fc56d7e33d2ef6f36197714a9cc6555b8b2ed108111bb03682bf872c651f0"
    sha256 x86_64_linux:  "8ead71356c27f8ed9ee840637be23367988055fe78df9fb28651e34987e3c1fd"
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