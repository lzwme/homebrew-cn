class Libaec < Formula
  desc "Adaptive Entropy Coding implementing Golomb-Rice algorithm"
  homepage "https://gitlab.dkrz.de/k202009/libaec"
  license "BSD-2-Clause"
  revision 1
  head "https://gitlab.dkrz.de/k202009/libaec.git", branch: "master"

  stable do
    url "https://gitlab.dkrz.de/k202009/libaec/-/archive/v1.1.4/libaec-v1.1.4.tar.bz2"
    sha256 "cf869c166656a83857adf62a092311a0069855c6ced3446e3f090a6d52279f65"

    # Backport commit needed to build gdal with HDF5 2.0.0
    patch do
      url "https://github.com/MathisRosenhauer/libaec/commit/2c6619c1313826df864065427055ed14c83d1998.patch?full_index=1"
      sha256 "513af4b0e24f23e84e4416fa52ad87e4058be364fab627a3b728bdd25074f17b"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6e7b1c24e7985960eec07aa6e1d17c5ec678715aaeebe58a97284d21c4919010"
    sha256 cellar: :any,                 arm64_sequoia: "3acd842c8ac138ae7459401e6019a8f4974b59b162d2df161f296b072f0cf29e"
    sha256 cellar: :any,                 arm64_sonoma:  "60105095768ff9f169acfacf1993fbd6e4b3b5606fa3a20922c34a638cbd4fa0"
    sha256 cellar: :any,                 sonoma:        "bb50b30a32e031ae6ee15db6f97bb0bf6ddd88a188b7f7a98200baef767250ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8764ca35bda1f432c360fed0799de5cfb9919dc7f1855659a4f559d8c475924e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1e769b1fb71bc71a5f3cea7597718c797f472bddb602924cf044a2158ac00a0"
  end

  depends_on "cmake" => [:build, :test]

  # These may have been linked by `szip` before keg_only change
  link_overwrite "include/szlib.h"
  link_overwrite "lib/libsz.a"
  link_overwrite "lib/libsz.dylib"
  link_overwrite "lib/libsz.2.dylib"
  link_overwrite "lib/libsz.so"
  link_overwrite "lib/libsz.so.2"

  def install
    # run ctest for libraries, also added `"-DBUILD_TESTING=ON` in the end as
    # `std_cmake_args` has `BUILD_TESTING` off
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DBUILD_TESTING=ON"
    system "cmake", "--build", "build"
    system "ctest", "--test-dir", "build", "--verbose"
    system "cmake", "--install", "build"
  end

  test do
    # Check directory structure of CMake file in case new release changed layout
    assert_path_exists lib/"cmake/libaec/libaec-config.cmake"

    (testpath/"test.cpp").write <<~CPP
      #include <cassert>
      #include <cstddef>
      #include <cstdlib>
      #include <libaec.h>
      int main() {
        unsigned char * data = (unsigned char *) calloc(1024, sizeof(unsigned char));
        unsigned char * compressed = (unsigned char *) calloc(1024, sizeof(unsigned char));
        for(int i = 0; i < 1024; i++) { data[i] = (unsigned char)(i); }
        struct aec_stream strm;
        strm.bits_per_sample = 16;
        strm.block_size      = 64;
        strm.rsi             = 129;
        strm.flags           = AEC_DATA_PREPROCESS | AEC_DATA_MSB;
        strm.next_in         = data;
        strm.avail_in        = 1024;
        strm.next_out        = compressed;
        strm.avail_out       = 1024;
        assert(aec_encode_init(&strm) == 0);
        assert(aec_encode(&strm, AEC_FLUSH) == 0);
        assert(strm.total_out > 0);
        assert(aec_encode_end(&strm) == 0);
        free(data);
        free(compressed);
        return 0;
      }
    CPP

    # Test CMake config package can be automatically found
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.10)
      project(test LANGUAGES CXX)

      find_package(libaec CONFIG REQUIRED)

      add_executable(test test.cpp)
      target_link_libraries(test libaec::aec)
    CMAKE

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "./build/test"
  end
end