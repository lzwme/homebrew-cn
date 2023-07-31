class CppHttplib < Formula
  desc "C++ header-only HTTP/HTTPS server and client library"
  homepage "https://github.com/yhirose/cpp-httplib"
  url "https://ghproxy.com/https://github.com/yhirose/cpp-httplib/archive/refs/tags/v0.13.2.tar.gz"
  sha256 "b7f64402082af7c42c0d370543cb294d82959ca7cf25b3ee7eb1306732bb27d4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f2527cb43683c1b21c949f9f169c655c73714afc3b1e8c4333eb79068441302"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f2527cb43683c1b21c949f9f169c655c73714afc3b1e8c4333eb79068441302"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f2527cb43683c1b21c949f9f169c655c73714afc3b1e8c4333eb79068441302"
    sha256 cellar: :any_skip_relocation, ventura:        "3f2527cb43683c1b21c949f9f169c655c73714afc3b1e8c4333eb79068441302"
    sha256 cellar: :any_skip_relocation, monterey:       "3f2527cb43683c1b21c949f9f169c655c73714afc3b1e8c4333eb79068441302"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f2527cb43683c1b21c949f9f169c655c73714afc3b1e8c4333eb79068441302"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e36dc140280611df253110acf657c7f3650481c31f6536b2615dfe8e5f57f62"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  fails_with :clang do
    build 1300
    cause <<~EOS
      include/httplib.h:5278:19: error: no viable overloaded '='
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
    (testpath/"server.cpp").write <<~CPP
      #include <httplib.h>
      using namespace httplib;

      int main(void) {
        Server svr;

        svr.Get("/hi", [](const Request &, Response &res) {
          res.set_content("Hello World!", "text/plain");
        });

        svr.listen("0.0.0.0", 8080);
      }
    CPP
    (testpath/"client.cpp").write <<~CPP
      #include <httplib.h>
      #include <iostream>
      using namespace httplib;
      using namespace std;

      int main(void) {
        Client cli("localhost", 8080);
        if (auto res = cli.Get("/hi")) {
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
      exec "./server"
    end
    sleep 3
    assert_match "Hello World!", shell_output("./client")
  end
end