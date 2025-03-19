class Liblcf < Formula
  desc "Library for RPG Maker 20002003 games data"
  homepage "https:easyrpg.org"
  license "MIT"
  revision 6
  head "https:github.comEasyRPGliblcf.git", branch: "master"

  stable do
    url "https:easyrpg.orgdownloadsplayer0.8liblcf-0.8.tar.xz"
    sha256 "6b0d8c7fefe3d66865336406f69ddf03fe59e52b5601687265a4d1e47a25c386"

    # Backport C++17 for `icu4c` 75. Remove in the next release.
    patch do
      url "https:github.comEasyRPGliblcfcommit8c782e54ba244981141d91e7d44922952563677c.patch?full_index=1"
      sha256 "593f729e7f9a5411e6d8548aaac0039e09eee437f525409a9ca8513a0ee15cd0"
    end

    # Backport CMake fix when using FindEXPAT
    patch do
      url "https:github.comEasyRPGliblcfcommita759e18d39cd73c0d2934896ed5c9520a9e1ca94.patch?full_index=1"
      sha256 "4b34c80fbb80f388a3c08cf9e810a13c58e79c11671fc5064a54c1b6c0d5956d"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e1151274ab64086b4a8aaa60158ec06b5ae873a01f509938b2f04ab61101195f"
    sha256 cellar: :any,                 arm64_sonoma:  "d978147a8f8c7dbcfd7162ac2b42082fccc315f74f7e64f5f78a3271df73f77d"
    sha256 cellar: :any,                 arm64_ventura: "88b64f5e02c66eba7184bfbecdda6dfb6f331c3ad113b89f7400e51cad4a90da"
    sha256 cellar: :any,                 sonoma:        "ab362e5a999bd3210a26c2c2e431135a51ae43cc7a6dd6371a3ab07a93438795"
    sha256 cellar: :any,                 ventura:       "dc447f1a04732969f18f1d32f1fd6ecce02c4115f9b1031f71f0008843618bfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5415f715fd1e60c8e1cb80a633588d4afd743b309d760c12f483e0881746e646"
  end

  depends_on "cmake" => :build
  depends_on "icu4c@77"

  uses_from_macos "expat"

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