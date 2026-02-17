class ZxingCpp < Formula
  desc "Multi-format barcode image processing library written in C++"
  homepage "https://github.com/zxing-cpp/zxing-cpp"
  url "https://ghfast.top/https://github.com/zxing-cpp/zxing-cpp/releases/download/v3.0.1/zxing-cpp-3.0.1-homebrew.tar.gz"
  sha256 "c0f210924955785004150c71d77306da8c6461b5db6abdb323fc331d6a213876"
  license "Apache-2.0"
  head "https://github.com/zxing-cpp/zxing-cpp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "18ea1b16214084445c7e74b143d4985aba52702a4ebf0523b5e7b930271d7a52"
    sha256 cellar: :any,                 arm64_sequoia: "2a9611050e2026b1aa591b390b609f55f45b2465b03f255305e6f2a0d7ed91e5"
    sha256 cellar: :any,                 arm64_sonoma:  "9d1a9af0311577b559b455d032dc1c92e9b0157afba42e80c0658c0a0c0944f1"
    sha256 cellar: :any,                 sonoma:        "f2b04a8b3053dc47035220d526df7bf851c0140c1acae7c7a213758bc37e5f58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "168aa61e7cbb561fb6de96986d0765beea11a4f3d1bf78332029423835d678ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68d0c01fed83e9bca106bd13ded01f19c95d6a9a541463a14b270c3163354079"
  end

  depends_on "cmake" => :build

  def install
    args = %w[
      -DZXING_C_API=OFF
      -DZXING_EXAMPLES=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <ZXing/ZXingCpp.h>
      int main() {
        ZXing::ReaderOptions options;
        (void)options;
        return 0;
      }
    CPP

    system ENV.cxx, "test.cpp", "-std=c++20", "-I#{include}", "-L#{lib}", "-lZXing", "-o", "test"
    system "./test"
  end
end