class UnorderedDense < Formula
  desc "Hashmap and hashset based on robin-hood backward shift deletion"
  homepage "https://github.com/martinus/unordered_dense"
  url "https://ghfast.top/https://github.com/martinus/unordered_dense/archive/refs/tags/v4.9.1.tar.gz"
  sha256 "02d062c0238215bd842328e6544dcd02801645e7d9c224b113890aff80194fa3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7cb110c35350f71fe5a8d0722956e4da086849dc79b1dd0c97934a6bb63bf827"
  end

  depends_on "cmake" => :build

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