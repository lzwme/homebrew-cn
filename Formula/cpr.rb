class Cpr < Formula
  desc "C++ Requests, a spiritual port of Python Requests"
  homepage "https://docs.libcpr.org/"
  url "https://ghproxy.com/https://github.com/libcpr/cpr/archive/1.10.3.tar.gz"
  sha256 "7b9d3504ffdaf7ce3189f1b91d135888776b6a1b26ea1bf2c3c4986b8a5af06f"
  license "MIT"
  head "https://github.com/libcpr/cpr.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d4b86b8146b0519e591952c579afc6859e32fa8c3e54378bc30af19d7d7789b2"
    sha256 cellar: :any,                 arm64_monterey: "2cbbd1950fbcdd181851b6cb5d1376800c129a222f5a1c971dd4922883150b06"
    sha256 cellar: :any,                 arm64_big_sur:  "4fa3fe8c2a89d078e452b3ccae10f3dc9ef5e9b653051dffe208b492d4bedadb"
    sha256 cellar: :any,                 ventura:        "4e99b818d15283ff83a9b5d28cfb33bc01d49ed0a73d38d1eb02c21bbc4a6621"
    sha256 cellar: :any,                 monterey:       "7cc6b1262eeda456de28ac9da96980465429bf8ca125b5cd63f27e899319c9e5"
    sha256 cellar: :any,                 big_sur:        "9493efcd95d7f8addf514b01f4a443f91741e2074d51c1c770a8ccf34ac4dbcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "395435ea43e0b7b68fe835c1aa4aee965be193419cebc2e41d2021cf1c3fbf91"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl", since: :monterey # Curl 7.68+

  on_linux do
    depends_on "openssl@3"
  end

  fails_with gcc: "5" # C++17

  def install
    args = %W[
      -DCPR_USE_SYSTEM_CURL=ON
      -DCPR_BUILD_TESTS=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ] + std_cmake_args

    ENV.append_to_cflags "-Wno-error=deprecated-declarations"
    system "cmake", "-S", ".", "-B", "build-shared", "-DBUILD_SHARED_LIBS=ON", *args
    system "cmake", "--build", "build-shared"
    system "cmake", "--install", "build-shared"

    system "cmake", "-S", ".", "-B", "build-static", "-DBUILD_SHARED_LIBS=OFF", *args
    system "cmake", "--build", "build-static"
    lib.install "build-static/lib/libcpr.a"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <curl/curl.h>
      #include <cpr/cpr.h>

      int main(int argc, char** argv) {
          auto r = cpr::Get(cpr::Url{"https://example.org"});
          std::cout << r.status_code << std::endl;

          return 0;
      }
    EOS

    args = %W[
      -I#{include}
      -L#{lib}
      -lcpr
    ]
    args << "-I#{Formula["curl"].opt_include}" if MacOS.version <= :big_sur

    system ENV.cxx, "test.cpp", "-std=c++17", *args, "-o", testpath/"test"
    assert_match "200", shell_output("./test")
  end
end