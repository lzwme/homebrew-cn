class Dartsim < Formula
  desc "Dynamic Animation and Robotics Toolkit"
  homepage "https://dartsim.github.io/"
  url "https://ghfast.top/https://github.com/dartsim/dart/archive/refs/tags/v6.20.1.tar.gz"
  sha256 "f6799dd17303c478bee6fc5f439108ccf7b2870f712884d4bdb85fcf9d2b1778"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256               arm64_golden_gate: "7d746ec1477025edc137e589b1053793685fa41996593ab4e0a43ce40f49fafd"
    sha256               arm64_tahoe:       "dfe2b76655c2513eab2f60e1768bf809703b639a795fe081857c9afdbbdc6cef"
    sha256               arm64_sequoia:     "e4def02dfa8f947b1e2e607e46139592ba4785f63a14ba060346c0d86ce9ac00"
    sha256               arm64_linux:       "629d9d734e03ff6c09f60e379ab9640080cdca4c55753da142c325687011cece"
    sha256 cellar: :any, x86_64_linux:      "7cbec50a7e5eb8edbd903d750af3a289903a550de177e5ed650863cd5d284d57"
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

  # Keep DART's bundled ImGui compatibility patches without downloading during CMake.
  resource "imgui" do
    url "https://ghfast.top/https://github.com/ocornut/imgui/archive/refs/tags/v1.92.8.tar.gz"
    sha256 "fecb33d33930e12ff53a34064e9d3a06c8f7c3e04408f14cd36c80e3faac863b"

    livecheck do
      url "https://ghfast.top/https://raw.githubusercontent.com/dartsim/dart/refs/tags/v#{LATEST_VERSION}/dart/gui/imgui/CMakeLists.txt"
      regex(/set\(IMGUI_TARGET_VERSION\s+"v?(\d+(?:\.\d+)+)"\)/i)
    end
  end

  def install
    resource("imgui").stage buildpath/"imgui"

    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DDART_BUILD_DARTPY=OFF
      -DDART_ENABLE_SIMD=OFF
      -DFETCHCONTENT_SOURCE_DIR_DART_IMGUI=#{buildpath}/imgui
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
    system ENV.cxx, "test.cpp", "-I#{formula_opt_include("eigen")}/eigen3",
                    "-I#{include}", "-L#{lib}", "-ldart",
                    "-L#{formula_opt_lib("assimp")}", "-lassimp",
                    "-L#{formula_opt_lib("libccd")}", "-lccd",
                    "-L#{formula_opt_lib("fcl")}", "-lfcl",
                    "-std=c++17", "-o", "test"
    system "./test"
    system "cmake", "-S", ".", "-B", "build"
    system "cmake", "--build", "build"
    system "build/test_cmake"
  end
end