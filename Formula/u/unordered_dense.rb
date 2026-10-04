class UnorderedDense < Formula
  desc "Hashmap and hashset based on robin-hood backward shift deletion"
  homepage "https://github.com/martinus/unordered_dense"
  url "https://ghfast.top/https://github.com/martinus/unordered_dense/archive/refs/tags/v5.3.0.tar.gz"
  sha256 "ca1cc1c7bc73d9a77680aa2a38ea9ec43340242e3f9dc04e129f06accc56ec88"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "04bd369eb41a9b9927761988f9a26b14ee441433623c0685476cd786cd0ca42b"
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