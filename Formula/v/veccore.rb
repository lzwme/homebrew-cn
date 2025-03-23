class Veccore < Formula
  desc "C++ Library for Portable SIMD Vectorization"
  homepage "https:github.comroot-projectveccore"
  url "https:github.comroot-projectveccorearchiverefstagsv0.8.2.tar.gz"
  sha256 "1268bca92acf00acd9775f1e79a2da7b1d902733d17e283e0dd5e02c41ac9666"
  license "Apache-2.0"
  head "https:github.comroot-projectveccore.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7cb81dd2bcb91896afae27ce9431387752ef9a6a443da7767a6bef6faa945a4b"
  end

  depends_on "cmake" => :build
  depends_on "vc"

  def install
    args = %w[
      -DUMESIMD=OFF
      -DVC=ON
    ]

    system "cmake", "-S", ".", "-B", "builddir", *args, *std_cmake_args
    system "cmake", "--build", "builddir"
    system "cmake", "--install", "builddir"
  end

  test do
    (testpath"test.cpp").write <<~CPP
      #include <VecCoreVecCore>
      #include <iostream>
      auto main() -> int {
        std::cout<<vecCore::Rad<double>(0.0)<<std::endl;
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++20", "-o", "test"
    assert_equal "0", shell_output(".test").chomp
  end
end