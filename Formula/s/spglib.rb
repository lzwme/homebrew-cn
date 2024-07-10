class Spglib < Formula
  desc "C library for finding and handling crystal symmetries"
  homepage "https:spglib.readthedocs.io"
  url "https:github.comspglibspglibarchiverefstagsv2.5.0.tar.gz"
  sha256 "80c060b1a606a76b15f2cc708e9fdd4a83479924ebff9ac16ed26a87a0eac1a9"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "87cc4a9d8fa45ce98963930405160196f2ac322070ca4dd994ece719706ced42"
    sha256 cellar: :any,                 arm64_ventura:  "3dced6938cf16477fd60b24fb025f634f64555a5cbaceb880705c7bd8d7fb28c"
    sha256 cellar: :any,                 arm64_monterey: "614d1f10c66cceaa0c5103e110cadd0e56562488e2d41269e5bfde4c665bdd40"
    sha256 cellar: :any,                 sonoma:         "c54b6e9e3123656c2ee5ae36aaaa4f88c1b820abbe155b6b8c2d19c1dd3ebfb6"
    sha256 cellar: :any,                 ventura:        "8f27f51353ea2965ce0bac10adb0086b810607c699bb9c1595b3dd18a5bfea5f"
    sha256 cellar: :any,                 monterey:       "2239cc40e94b32ec55bf8d7ce0854e400fefe37aea725a5431e7bc9fed4b5bc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a37dcc5ec9431b396478aafa2d7e82bdcd41baf93b83ed3c4682075dbb6e46b"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "gcc" # for gfortran

  def install
    # TODO: Fortran packaging is disabled for now because packaging does not pick it up properly
    # https:github.comspglibspglibissues352#issuecomment-1784943807
    common_args = %w[
      -DSPGLIB_WITH_Fortran=OFF
      -DSPGLIB_WITH_TESTS=OFF
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