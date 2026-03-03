class Seqan3 < Formula
  desc "Modern C++ library for sequence analysis"
  homepage "https://www.seqan.de"
  url "https://ghfast.top/https://github.com/seqan/seqan3/releases/download/3.4.1/seqan3-3.4.1-Source.tar.xz"
  sha256 "23d061c2a898ea56ddc45ba731e0a80f2f59fefca90977cae3408bde6a8748a3"
  license all_of: ["BSD-3-Clause", "CC-BY-4.0", "CC0-1.0", "MIT", "Zlib"]

  bottle do
    sha256 cellar: :any_skip_relocation, all: "50312c448c0fead8614ee076b90cdd71413ab0f2f80c2d76544f5bfc743f12b3"
  end

  depends_on "cereal" => :build
  depends_on "cmake" => :build

  on_macos do
    depends_on "gcc" => :test if DevelopmentTools.clang_build_version < 1700
  end

  def install
    args = %w[-DCPM_LOCAL_PACKAGES_ONLY=ON]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <seqan3/core/debug_stream.hpp>

      int main() {
        seqan3::debug_stream << "Hello World!\\n";
        return 0;
      }
    CPP

    ENV.method("gcc-#{Formula["gcc"].version.major}").call if OS.mac? && DevelopmentTools.clang_build_version < 1700
    system ENV.cxx, "-std=c++23", "test.cpp", "-o", "test"
    system "./test"
  end
end