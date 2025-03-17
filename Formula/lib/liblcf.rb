class Liblcf < Formula
  desc "Library for RPG Maker 20002003 games data"
  homepage "https:easyrpg.org"
  license "MIT"
  revision 5
  head "https:github.comEasyRPGliblcf.git", branch: "master"

  stable do
    url "https:easyrpg.orgdownloadsplayer0.8liblcf-0.8.tar.xz"
    sha256 "6b0d8c7fefe3d66865336406f69ddf03fe59e52b5601687265a4d1e47a25c386"

    # Backport C++17 for `icu4c` 75. Remove in the next release.
    patch do
      url "https:github.comEasyRPGliblcfcommit8c782e54ba244981141d91e7d44922952563677c.patch?full_index=1"
      sha256 "593f729e7f9a5411e6d8548aaac0039e09eee437f525409a9ca8513a0ee15cd0"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0ce1d52bf550672b277c189f92aa81e25b40a8b9342c31974a8da8d037311565"
    sha256 cellar: :any,                 arm64_sonoma:  "3eb59771db72f108f7e2345aaf4095f55e621ace5b95a7af03f374ac34784b27"
    sha256 cellar: :any,                 arm64_ventura: "d159fe2f340bf3ad58f1e730ce8b739e4e38deeeb5e87702d235754cc158b409"
    sha256 cellar: :any,                 sonoma:        "deb6d3ce9b1ff44726207ba6754a80ba56f541e73c0332f4543d388caf3e0f6d"
    sha256 cellar: :any,                 ventura:       "26b9bedec364a4e139c5db09ebdac6979b36581c29387994083a3e502fcb8df6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "743579b1d4cd94e49240f8ed6f432c146123764f5692cab39b477de090055a1a"
  end

  depends_on "cmake" => :build
  depends_on "expat" # Building against `liblcf` fails with `uses_from_macos`
  depends_on "icu4c@77"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DLIBLCF_UPDATE_MIMEDB=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.cpp").write <<~CPP
      #include "lcflsdreader.h"
      #include <cassert>

      int main() {
        std::time_t const current = std::time(NULL);
        assert(current == lcf::LSD_Reader::ToUnixTimestamp(lcf::LSD_Reader::ToTDateTime(current)));
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++14", "-I#{include}", "-L#{lib}", "-llcf", \
      "-o", "test"
    system ".test"
  end
end