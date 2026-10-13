class Cpr < Formula
  desc "C++ Requests, a spiritual port of Python Requests"
  homepage "https://docs.libcpr.org/"
  url "https://ghfast.top/https://github.com/libcpr/cpr/archive/refs/tags/1.15.0.tar.gz"
  sha256 "dfd98b3a176a1f9ec20cbfe985d65426c1c9d4439411348cd5567ac2f075ec92"
  license "MIT"
  head "https://github.com/libcpr/cpr.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9d07634667f33d6b422b9f87b3c21115a7244c33c62cdef84f9f6b69e8fad415"
    sha256 cellar: :any, arm64_tahoe:       "28baa6e614e9e84bb64211b9d94e2c5e75cc4ba3ea818d316b84ed373cd34b6d"
    sha256 cellar: :any, arm64_sequoia:     "81ac575b8a3d500481541a95d6c1fcd410036c7afcc92d4b8ff6e5c0445f9594"
    sha256 cellar: :any, arm64_linux:       "23c9528a94106bab50c5ccb61c7d6c5b37bec1e1777841df1b244e3b61242a1f"
    sha256 cellar: :any, x86_64_linux:      "996ba50d8e824ad0c1004fed7582c06f925b076105bdd693b4755aba7c5f0d36"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl", since: :monterey # Curl 7.68+

  on_linux do
    depends_on "openssl@4"
  end

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
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <curl/curl.h>
      #include <cpr/cpr.h>

      int main(int argc, char** argv) {
          auto r = cpr::Get(cpr::Url{"https://example.org"});
          std::cout << r.status_code << std::endl;

          return 0;
      }
    CPP

    args = %W[
      -I#{include}
      -L#{lib}
      -lcpr
    ]
    args << "-I#{formula_opt_include("curl")}" if !OS.mac? || MacOS.version <= :big_sur

    system ENV.cxx, "test.cpp", "-std=c++17", *args, "-o", testpath/"test"
    assert_match "200", shell_output("./test")
  end
end