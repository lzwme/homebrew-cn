class CppHttplib < Formula
  desc "C++ header-only HTTPHTTPS server and client library"
  homepage "https:github.comyhirosecpp-httplib"
  url "https:github.comyhirosecpp-httplibarchiverefstagsv0.20.0.tar.gz"
  sha256 "18064587e0cc6a0d5d56d619f4cbbcaba47aa5d84d86013abbd45d95c6653866"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "70df6001086b72b94cfb273d721e63c67da0f7d0f4961e5ffad63e289cb69f04"
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