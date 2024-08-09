class CppHttplib < Formula
  desc "C++ header-only HTTPHTTPS server and client library"
  homepage "https:github.comyhirosecpp-httplib"
  url "https:github.comyhirosecpp-httplibarchiverefstagsv0.16.2.tar.gz"
  sha256 "75565bcdf12522929a26fb57a2c7f8cc0e175e27a9ecf51616075f3ea960da44"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "59768ace2859c185226f88badc8f15f5d4e9e528e5ec4092658d3a6194d17b59"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  fails_with :clang do
    build 1300
    cause <<~EOS
      includehttplib.h:5278:19: error: no viable overloaded '='
      request.matches = {};
      ~~~~~~~~~~~~~~~ ^ ~~
    EOS
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
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