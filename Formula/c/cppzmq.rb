class Cppzmq < Formula
  desc "Header-only C++ binding for libzmq"
  homepage "https:www.zeromq.org"
  url "https:github.comzeromqcppzmqarchiverefstagsv4.10.0.tar.gz"
  sha256 "c81c81bba8a7644c84932225f018b5088743a22999c6d82a2b5f5cd1e6942b74"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d454ccf680d7bada36024214a31369dc301c2a0aeeae0852b8d23d97b6457a36"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "zeromq"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCPPZMQ_BUILD_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples"
  end

  test do
    cp pkgshare"exampleshello_world.cpp", testpath
    system ENV.cxx, "-std=c++11", "hello_world.cpp", "-I#{include}",
                    "-L#{Formula["zeromq"].opt_lib}", "-lzmq", "-o", "test"
    system ".test"
  end
end