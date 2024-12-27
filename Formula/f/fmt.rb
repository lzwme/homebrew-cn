class Fmt < Formula
  desc "Open-source formatting library for C++"
  homepage "https:fmt.dev"
  url "https:github.comfmtlibfmtreleasesdownload11.1.0fmt-11.1.0.zip"
  sha256 "e32d42c6be8df768d744bf0e7d4d69c4ccdce0eda44292ba5265add817413f17"
  license "MIT"
  head "https:github.comfmtlibfmt.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7a964b5939a4e8524ab607482153104616e5b5098ba4909a4836d4d34115b048"
    sha256 cellar: :any,                 arm64_sonoma:  "43c8236da42ea4aaecd53306e72751f0d40d70c9e2b7a806cc184eab0549ba07"
    sha256 cellar: :any,                 arm64_ventura: "37cae5515fc4b0197a9fe4e8f2a46894586cb33ca495f2d0c53aace72f29146d"
    sha256 cellar: :any,                 sonoma:        "f2330f1615aee3762e31bf91af979b7244ecff989485ebe06e16f32a049e1050"
    sha256 cellar: :any,                 ventura:       "51d86df28f37e81cd37ab38016ad1d6082ce52d039166347ba4d2f51ccd5ce8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ce985706a74f4499a9b2fd82fa4f44c5db44d4716d1ef3e3d37bb4704e7a574"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=TRUE", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    system "cmake", "-S", ".", "-B", "build-static", "-DBUILD_SHARED_LIBS=FALSE", *std_cmake_args
    system "cmake", "--build", "build-static"
    lib.install "build-staticlibfmt.a"
  end

  test do
    (testpath"test.cpp").write <<~CPP
      #include <iostream>
      #include <string>
      #include <fmtformat.h>
      int main()
      {
        std::string str = fmt::format("The answer is {}", 42);
        std::cout << str;
        return 0;
      }
    CPP

    system ENV.cxx, "test.cpp", "-std=c++11", "-o", "test",
                  "-I#{include}",
                  "-L#{lib}",
                  "-lfmt"
    assert_equal "The answer is 42", shell_output(".test")
  end
end