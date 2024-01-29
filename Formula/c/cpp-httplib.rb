class CppHttplib < Formula
  desc "C++ header-only HTTPHTTPS server and client library"
  homepage "https:github.comyhirosecpp-httplib"
  url "https:github.comyhirosecpp-httplibarchiverefstagsv0.15.0.tar.gz"
  sha256 "b658e625e283e2c81437a485a95f3acf8b1d32c53d8147b1ccecc8f630e1f7bb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d4c7d6bb5aee7a0058b592b93d4c911e6643a1671ada76c0d6fb32442f3a7bea"
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