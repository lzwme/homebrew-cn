class Spglib < Formula
  desc "C library for finding and handling crystal symmetries"
  homepage "https:spglib.readthedocs.io"
  url "https:github.comspglibspglibarchiverefstagsv2.3.0.tar.gz"
  sha256 "2fc3b42867d12a41b952ffd5896426797a39564e129c04c9c626d880371614ad"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "92de302b019697597d7b9e9588970fee151895ba2fd3c935853c9c65fd8e14c7"
    sha256 cellar: :any,                 arm64_ventura:  "e7dd7ff4505de0dbe9e0a126506cd15b1a55633d43ace7c72881a444dabe5064"
    sha256 cellar: :any,                 arm64_monterey: "a288fe3c5cbd6b5951c88e49bb5fc85701e496e9bb12ef09b22dcfd9414fc2de"
    sha256 cellar: :any,                 sonoma:         "ea29a24a074161d6241624a0f56965528e53e8df2ffc08b44b04118bc3f6afb6"
    sha256 cellar: :any,                 ventura:        "3ffe948bd7caa70bfa6ae1bf241a404737d18ae9ca95118b800849b4865d23d8"
    sha256 cellar: :any,                 monterey:       "cb113855fce0d78c9ef527f2295d6c4d1270f858a2443d458fac8194e1b464d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd07f189cc606c47bdb5a9b2a887aebdff994e795121aa8a886c45aa4ecb83c5"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "gcc" # for gfortran

  def install
    # TODO: Fortran packaging is disabled for now because packaging does not pick it up properly
    # https:github.comspglibspglibissues352#issuecomment-1784943807
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
    (testpath  "test.c").write <<~EOS
      #include <stdio.h>
      #include <spglib.h>
      int main()
      {
        printf("%d.%d.%d", spg_get_major_version(), spg_get_minor_version(), spg_get_micro_version());
      }
    EOS

    (testpath  "CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.6)
      project(test_spglib LANGUAGES C)
      find_package(Spglib CONFIG REQUIRED COMPONENTS shared)
      add_executable(test_c test.c)
      target_link_libraries(test_c PRIVATE Spglib::symspg)
    EOS
    system "cmake", "-B", "build_shared"
    system "cmake", "--build", "build_shared"
    system ".build_sharedtest_c"

    (testpath  "CMakeLists.txt").delete
    (testpath  "CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.6)
      project(test_spglib LANGUAGES C Fortran)
      find_package(Spglib CONFIG REQUIRED COMPONENTS static)
      add_executable(test_c test.c)
      target_link_libraries(test_c PRIVATE Spglib::symspg)
    EOS
    system "cmake", "-B", "build_static"
    system "cmake", "--build", "build_static"
    system ".build_statictest_c"
  end
end