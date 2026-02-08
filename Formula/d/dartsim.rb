class Dartsim < Formula
  desc "Dynamic Animation and Robotics Toolkit"
  homepage "https://dartsim.github.io/"
  url "https://ghfast.top/https://github.com/dartsim/dart/archive/refs/tags/v6.16.6.tar.gz"
  sha256 "e61435cd5fb12025c7dce8020088a64701a50d90f63e9b8a0f77e447d120bdae"
  license "BSD-2-Clause"
  revision 1

  bottle do
    sha256                               arm64_tahoe:   "7a61b6653aed6163e3a1251055a425e723ca7e5c77cb22067471a92b7818f797"
    sha256                               arm64_sequoia: "540359e69e8be2800b6fb444ee3a4666d7d6211bc06b4a96dd82f4ebb66e44de"
    sha256                               arm64_sonoma:  "63c255fcdc01d1fc3ed970c7a5a002f5d4b45a969ab0e5e8483e9683cbda023c"
    sha256                               sonoma:        "26100541ae86ec96211660b40285a9c311b03864b38ab909c59887965312f1f8"
    sha256                               arm64_linux:   "f82f2ad8a033c4bdca44b74e65567132c647405bf39cd1bce27d455cfcc1b68c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef4b658439479aec7c9e31f5de78c15449cd9e92fd4fea4a79845d7646063a20"
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