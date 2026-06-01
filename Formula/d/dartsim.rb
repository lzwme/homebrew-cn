class Dartsim < Formula
  desc "Dynamic Animation and Robotics Toolkit"
  homepage "https://dartsim.github.io/"
  url "https://ghfast.top/https://github.com/dartsim/dart/archive/refs/tags/v6.16.8.tar.gz"
  sha256 "bb4928d37a2e1296c3d29b63e968d0139b3dd3e2eb03c99a462ef32c0c373d94"
  license "BSD-2-Clause"

  bottle do
    sha256               arm64_tahoe:   "15be9297a1469bfb0bc5ff59cff3a44ef76f270f01ba4769377a1cb49584f6af"
    sha256               arm64_sequoia: "4885ace5eede2dc2c061e39f8fe56ba0ba504f7481935069c357846b6d75ba6c"
    sha256               arm64_sonoma:  "5742bbefb8ddd6ee48a90ea04cd08db24232c95c27aee31c767b09d6ac251e72"
    sha256               sonoma:        "ce9bca1b3455242997b1b9160dfc4bc48c81ed25754bf255e6f25b829c1cb7f5"
    sha256               arm64_linux:   "ea7ec35f1eaa72cbd251d0df85feef8078d516233ec333dce8a5be2cca77a292"
    sha256 cellar: :any, x86_64_linux:  "9350b5cac40408b97b38f006b3259e08802d01b37a75e370ce12d2bb374b46f5"
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