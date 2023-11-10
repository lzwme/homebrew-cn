class Spglib < Formula
  desc "C library for finding and handling crystal symmetries"
  homepage "https://spglib.readthedocs.io/"
  url "https://ghproxy.com/https://github.com/spglib/spglib/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "31bca273a1bc54e1cff4058eebe7c0a35d5f9b489579e84667d8e005c73dcc13"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "67803d095d3ea1f27f80c65c91702ce6c6d51b0a639467f9abf978c9ca0d0b24"
    sha256 cellar: :any,                 arm64_ventura:  "809d385dcbda7f5f2051adbad883bbdede6b34fa5eb8b5d14e95427071c33b56"
    sha256 cellar: :any,                 arm64_monterey: "d42e88acf4aec81f3b8be03b8a88bd18ae32bae2503a0adb88425e59aa9cfd1f"
    sha256 cellar: :any,                 sonoma:         "1688ef9515e42a9810752d453ffcbbb62305cd06df7ce6b5f204d2dd78ebead4"
    sha256 cellar: :any,                 ventura:        "b286554489884d54297dd3225494e47eec8c0606a24a7b4f83abed22ce019204"
    sha256 cellar: :any,                 monterey:       "b5521db6b9b81324e6d7ebf5eae3b55afadb1c389785768b2c4516b3e99a4847"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc0b5510db0b9c8405f345f2b21d086647c0ca9859f2f18827209ccaa3e80bdf"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "gcc" # for gfortran

  def install
    # TODO: Fortran packaging is disabled for now because packaging does not pick it up properly
    # https://github.com/spglib/spglib/issues/352#issuecomment-1784943807
    common_args = %w[
      -DSPGLIB_WITH_Fortran=OFF
    ]
    system "cmake", "-S", ".", "-B", "build_shared",
                   *common_args, "-DSPGLIB_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"

    system "cmake", "-S", ".", "-B", "build_static",
                  *common_args, "-DSPGLIB_SHARED_LIBS=OFF", *std_cmake_args
    system "cmake", "--build", "build_static"
    system "cmake", "--install", "build_static"
  end

  test do
    (testpath / "test.c").write <<~EOS
      #include <stdio.h>
      #include <spglib.h>
      int main()
      {
        printf("%d.%d.%d", spg_get_major_version(), spg_get_minor_version(), spg_get_micro_version());
      }
    EOS

    (testpath / "CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.6)
      project(test_spglib LANGUAGES C)
      find_package(Spglib CONFIG REQUIRED COMPONENTS shared)
      add_executable(test_c test.c)
      target_link_libraries(test_c PRIVATE Spglib::symspg)
    EOS
    system "cmake", "-B", "build_shared"
    system "cmake", "--build", "build_shared"
    system "./build_shared/test_c"

    (testpath / "CMakeLists.txt").delete
    (testpath / "CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.6)
      project(test_spglib LANGUAGES C Fortran)
      find_package(Spglib CONFIG REQUIRED COMPONENTS static)
      add_executable(test_c test.c)
      target_link_libraries(test_c PRIVATE Spglib::symspg)
    EOS
    system "cmake", "-B", "build_static"
    system "cmake", "--build", "build_static"
    system "./build_static/test_c"
  end
end