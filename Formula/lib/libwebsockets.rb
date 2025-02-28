class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https:github.comwarmcatlibwebsockets"
  url "https:github.comwarmcatlibwebsocketsarchiverefstagsv4.3.4.tar.gz"
  sha256 "896b36aa063b4d05865f9ffee4404b26d4c2d3e2ba17b0b69f021b615377845e"
  license "MIT"
  head "https:github.comwarmcatlibwebsockets.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sequoia: "ee84be2d45d95851f14f66952bca88b630b8495aa62f63e1e4082253815ba599"
    sha256 arm64_sonoma:  "850e5942baa1e06397f2ae76fe0f85fdf735430f22a7c83c8e5fc85d2c5ee152"
    sha256 arm64_ventura: "2230242f12b56d333912e7f168b0636a3c6728083624047e6721443b0f5d6810"
    sha256 sonoma:        "f88d2c205ba3d28c7fed59398cc4b17c9938cb9e2dfac789cba24092164887f9"
    sha256 ventura:       "52feaf9c2323762d027e1875249043510f23cd6cc8810f76f5448cd957cbcd7b"
    sha256 x86_64_linux:  "0b018a6b6a27be6450a97a06e5ee2bb6ddf8bc3a354fd6a2ab373cdd9b626df5"
  end

  depends_on "cmake" => :build
  depends_on "libevent"
  depends_on "libuv"
  depends_on "openssl@3"

  uses_from_macos "zlib"

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
    (testpath"test.c").write <<~C
      #include <opensslssl.h>
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
    system ENV.cc, "test.c", "-I#{Formula["openssl@3"].opt_prefix}include",
                   "-L#{lib}", "-lwebsockets", "-o", "test"
    system ".test"
  end
end