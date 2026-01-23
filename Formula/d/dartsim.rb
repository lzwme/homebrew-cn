class Dartsim < Formula
  desc "Dynamic Animation and Robotics Toolkit"
  homepage "https://dartsim.github.io/"
  url "https://ghfast.top/https://github.com/dartsim/dart/archive/refs/tags/v6.16.5.tar.gz"
  sha256 "ea1709540131718a1af8138a89687e9cb2c3d21304c4d773ae6d70815e843cf6"
  license "BSD-2-Clause"

  bottle do
    sha256                               arm64_tahoe:   "6aa5dc663ed9ead88c923696a692162969cae52f29054eb4859e8529145524f8"
    sha256                               arm64_sequoia: "9dfdab046191fcc7e1ea632eb5054c22fb173c39455270a5d14575378704ec3a"
    sha256                               arm64_sonoma:  "72ff4719a6ba87dab3afd4a46a695b0ede364f729906dab597ff5368a64ce773"
    sha256                               sonoma:        "0d9999bd67417071d68c4443e2c05abf33b47801159b71410e1923b0b62b794c"
    sha256                               arm64_linux:   "1d98618f75b3c75ecfa4bf071ca252d2d477dad314d0f45f61eea9d34ead8d3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2de237e1e710a5e85b355a3dc6bc6225e393d2a8af7d066f2056e130b8a4c737"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "pkgconf" => :build

  depends_on "assimp"
  depends_on "bullet"
  depends_on "eigen"
  depends_on "fcl"
  depends_on "flann"
  depends_on "fmt"
  depends_on "ipopt"
  depends_on "libccd"
  depends_on "nlopt"
  depends_on "octomap"
  depends_on "ode"
  depends_on "open-scene-graph"
  depends_on "spdlog"
  depends_on "tinyxml2"
  depends_on "urdfdom"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "mesa"
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DDART_BUILD_DARTPY=OFF
      -DDART_ENABLE_SIMD=OFF
    ]

    if OS.mac?
      # Force to link to system GLUT (see: https://cmake.org/Bug/view.php?id=16045)
      glut_lib = "#{MacOS.sdk_path}/System/Library/Frameworks/GLUT.framework"
      args << "-DGLUT_glut_LIBRARY=#{glut_lib}"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Clean up the build file garbage that has been installed.
    rm_r Dir["#{share}/doc/dart/**/CMakeFiles/"]
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <dart/dart.hpp>
      int main() {
        auto world = std::make_shared<dart::simulation::World>();
        assert(world != nullptr);
        return 0;
      }
    CPP
    (testpath/"CMakeLists.txt").write <<-CMAKE
      cmake_minimum_required(VERSION 3.22.1 FATAL_ERROR)
      find_package(DART QUIET REQUIRED CONFIG)
      add_executable(test_cmake test.cpp)
      target_link_libraries(test_cmake dart)
    CMAKE
    system ENV.cxx, "test.cpp", "-I#{Formula["eigen"].include}/eigen3",
                    "-I#{include}", "-L#{lib}", "-ldart",
                    "-L#{Formula["assimp"].opt_lib}", "-lassimp",
                    "-L#{Formula["libccd"].opt_lib}", "-lccd",
                    "-L#{Formula["fcl"].opt_lib}", "-lfcl",
                    "-std=c++17", "-o", "test"
    system "./test"
    # build with cmake
    mkdir "build" do
      system "cmake", ".."
      system "make"
      system "./test_cmake"
    end
  end
end