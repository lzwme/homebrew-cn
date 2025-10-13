class Dartsim < Formula
  desc "Dynamic Animation and Robotics Toolkit"
  homepage "https://dartsim.github.io/"
  url "https://ghfast.top/https://github.com/dartsim/dart/archive/refs/tags/v6.15.0.tar.gz"
  sha256 "bbf954e283f464f6d0a8a5ab43ce92fd49ced357ccdd986c7cb4c29152df8692"
  license "BSD-2-Clause"
  revision 5

  bottle do
    sha256                               arm64_tahoe:   "92da7a8f2f3d3d9ac902b342bd8cecac3c92c45912989eca3b26f19162c2d754"
    sha256                               arm64_sequoia: "9d082545f735cdc8346b99e5997a040982755e617df86dd5daf9d8b31c0d629d"
    sha256                               arm64_sonoma:  "e942497966e77892c058b93b3f7b87ea3c700c3024b07f58974a849a0c821717"
    sha256                               sonoma:        "a30afa492ec88166bed5ef9b16e7fa15a8dc02548462a4671f485da4f756f07d"
    sha256                               arm64_linux:   "98763929459cb560fc5b92dd7eafa2552685bd762ee40b0b9cf4d95727c6377b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "356b7b81fe3390f4c57402f62ccd7b6058766bb28ca5e87aa1a95090cba1bc24"
  end

  depends_on "cmake" => :build
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
    system ENV.cxx, "test.cpp", "-I#{Formula["eigen"].include}/eigen3",
                    "-I#{include}", "-L#{lib}", "-ldart",
                    "-L#{Formula["assimp"].opt_lib}", "-lassimp",
                    "-L#{Formula["libccd"].opt_lib}", "-lccd",
                    "-L#{Formula["fcl"].opt_lib}", "-lfcl",
                    "-std=c++17", "-o", "test"
    system "./test"
  end
end