class Nanoflann < Formula
  desc "Header-only library for Nearest Neighbor search with KD-trees"
  homepage "https://github.com/jlblancoc/nanoflann"
  url "https://ghfast.top/https://github.com/jlblancoc/nanoflann/archive/refs/tags/1.14.0.tar.gz"
  sha256 "62f0979556713e7c70cce21ead27aad78317111cb95b02dad2b7a0b8bfdf9f5f"
  license "BSD-3-Clause"
  head "https://github.com/jlblancoc/nanoflann.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2343c024772f583c687fa0a222a7248a623383eac9ec49c46b7be430f35e9409"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", "-DNANOFLANN_BUILD_EXAMPLES=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <nanoflann.hpp>
      int main() {
        nanoflann::KNNResultSet<size_t> resultSet(1);
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-o", "test", "-std=c++11"
    system "./test"
  end
end