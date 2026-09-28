class UnorderedDense < Formula
  desc "Hashmap and hashset based on robin-hood backward shift deletion"
  homepage "https://github.com/martinus/unordered_dense"
  url "https://ghfast.top/https://github.com/martinus/unordered_dense/archive/refs/tags/v5.2.0.tar.gz"
  sha256 "541a96c4227b32c0001d90e4c2b3373fe1e7004fd59a64f2667d6e490cdcdb88"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "67533bac29a748e031cd663c7fc14343d99f77254ef5ccaf1300fbeb66ed9472"
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