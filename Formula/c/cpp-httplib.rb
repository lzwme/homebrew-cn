class CppHttplib < Formula
  desc "C++ header-only HTTPHTTPS server and client library"
  homepage "https:github.comyhirosecpp-httplib"
  url "https:github.comyhirosecpp-httplibarchiverefstagsv0.18.6.tar.gz"
  sha256 "8900747bba3dda8007f1876175be699036e09e4a25ceeab51196d9365bf1993a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2b951d8582b21769a2f3a4a1dc5ba4e8044600a7471e3d984c1b0faecc5ad6ae"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3" => :build
  uses_from_macos "zlib" => :build

  fails_with :clang do
    build 1300
    cause <<~EOS
      includehttplib.h:5278:19: error: no viable overloaded '='
      request.matches = {};
      ~~~~~~~~~~~~~~~ ^ ~~
    EOS
  end

  def install
    # Set args for consistent dependencies used in generated CMake config
    args = %w[
      -DHTTPLIB_REQUIRE_OPENSSL=ON
      -DHTTPLIB_REQUIRE_ZLIB=ON
      -DHTTPLIB_USE_BROTLI_IF_AVAILABLE=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"server.cpp").write <<~CPP
      #include <httplib.h>
      using namespace httplib;

      int main(void) {
        Server svr;

        svr.Get("hi", [](const Request &, Response &res) {
          res.set_content("Hello World!", "textplain");
        });

        svr.listen("0.0.0.0", 8080);
      }
    CPP
    (testpath"client.cpp").write <<~CPP
      #include <httplib.h>
      #include <iostream>
      using namespace httplib;
      using namespace std;

      int main(void) {
        Client cli("localhost", 8080);
        if (auto res = cli.Get("hi")) {
          cout << res->status << endl;
          cout << res->get_header_value("Content-Type") << endl;
          cout << res->body << endl;
          return 0;
        } else {
          return 1;
        }
      }
    CPP
    system ENV.cxx, "server.cpp", "-I#{include}", "-lpthread", "-std=c++11", "-o", "server"
    system ENV.cxx, "client.cpp", "-I#{include}", "-lpthread", "-std=c++11", "-o", "client"

    fork do
      exec ".server"
    end
    sleep 3
    assert_match "Hello World!", shell_output(".client")
  end
end