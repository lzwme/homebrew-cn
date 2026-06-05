class Dartsim < Formula
  desc "Dynamic Animation and Robotics Toolkit"
  homepage "https://dartsim.github.io/"
  url "https://ghfast.top/https://github.com/dartsim/dart/archive/refs/tags/v6.17.0.tar.gz"
  sha256 "a5ab3e53dcaccc7bcc297e0ed0b31e348e26719f6c373751f6ee059d251b80a0"
  license "BSD-2-Clause"

  bottle do
    sha256               arm64_tahoe:   "46aab14798cfca4a149e30e76792e2bb2d1118bdb870f714646720ddcf277778"
    sha256               arm64_sequoia: "71021653d6585d1a37de4c66443caf94039f25f42830474f3c76ddb5c54a6773"
    sha256               arm64_sonoma:  "a56e57c85685a9785d76e92c5db3b70cdae204c1b9a71ba9a7b3018143a7e9a2"
    sha256               sonoma:        "36a09f572e0c933e59d73ae4a0e07fd56a8afe554268a9f9388794aa7c4db755"
    sha256               arm64_linux:   "6a9b7acb0b08382a976a5e3ce3f1d79adc5b0460c4e7c15f71f266ccfb06cd98"
    sha256 cellar: :any, x86_64_linux:  "78c2572b5a13826f4220a1f24444e28ddfbd88702726e08bf590d2f1a437d9b6"
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