class UnorderedDense < Formula
  desc "Hashmap and hashset based on robin-hood backward shift deletion"
  homepage "https://github.com/martinus/unordered_dense"
  url "https://ghfast.top/https://github.com/martinus/unordered_dense/archive/refs/tags/v5.3.1.tar.gz"
  sha256 "06c262f9d7e1ff94d92e0359f89cc5d8632f32dfffb5e176a10516c509f5e5f2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8d22fbf62a5ee595999b2f1948e4afc0e3ad0647cd32039809e3d5ef9ec26921"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "example"
  end

  test do
    cp pkgshare/"example/main.cpp", testpath
    system ENV.cxx, "-std=c++17", "main.cpp", "-o", "test"
    system "./test"
  end
end