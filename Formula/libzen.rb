class Libzen < Formula
  desc "Shared library for libmediainfo"
  homepage "https://github.com/MediaArea/ZenLib"
  url "https://mediaarea.net/download/source/libzen/0.4.41/libzen_0.4.41.tar.bz2"
  sha256 "eb237d7d3dca6dc6ba068719420a27de0934a783ccaeb2867562b35af3901e2d"
  license "Zlib"
  head "https://github.com/MediaArea/ZenLib.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "da213aea536f6e6312cf1f409f872d4590644d14fad71f145702c0f77474ac12"
    sha256 cellar: :any,                 arm64_monterey: "bd7e559c26dd6088526d421cb2ec338add6ca7ad3288c6198156461b7c68bf9a"
    sha256 cellar: :any,                 arm64_big_sur:  "4fceeb254d09cac66253165e7af91696e5340c59538d75cf8bffa9f60b6ab38e"
    sha256 cellar: :any,                 ventura:        "7e97e75f3f0b24b4d1556f5d99fde8156298c4161c3452b7a41c360a12d3fbfc"
    sha256 cellar: :any,                 monterey:       "743b421635ac0e3142420c409915569ea216a2dfa563e2554e60e22b8cadbe2b"
    sha256 cellar: :any,                 big_sur:        "d435ad412da0b4274965b6e3f57afddfb1657cce802a468f82fa9abc93352dd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8e91bd5cf4ebbdb4bcc5ef57773b7bd8f4f2fdf95f2a6f9ce2b03cc93145c43"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", "Project/CMake", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <ZenLib/Ztring.h>
      #include <iostream>
      int main() {
        ZenLib::Ztring myString = ZenLib::Ztring().From_UTF8("Hello, ZenLib!");
        std::cout << myString.To_UTF8() << std::endl;
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++17", "test.cc", "-I#{include}", "-L#{lib}", "-lzen", "-o", "test"
    system "./test"
  end
end