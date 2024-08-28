class Dartsim < Formula
  desc "Dynamic Animation and Robotics Toolkit"
  homepage "https:dartsim.github.io"
  url "https:github.comdartsimdartarchiverefstagsv6.14.4.tar.gz"
  sha256 "f5fc7f5cb1269cc127a1ff69be26247b9f3617ce04ff1c80c0f3f6abc7d9ab70"
  license "BSD-2-Clause"
  revision 1

  bottle do
    sha256                               arm64_sonoma:   "468365bfa660f1266bdaccb069494b2c18d7dba4c3e78e8bba0f2b20eae1ca89"
    sha256                               arm64_ventura:  "1ecf1a074e36d7b867ac11536ceaf46040cf228181668799f76b611f8a7917aa"
    sha256                               arm64_monterey: "c9126fcd35ec14ea6a08c91a8854c9de0bacfb16dfb605785a61b538beee8d03"
    sha256                               sonoma:         "5648e0d869d013c90a3171c766221901a689f38274d933d7000ae7d90629ca3f"
    sha256                               ventura:        "c8b1ebb4d5a18ecc72063c085a036041922bb3a82ac74005ae810ee01d41d2a6"
    sha256                               monterey:       "925e6b16b6c79e0be1832d233edb78f41a02e36c16d6c05570904f74b3dc3ed1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97c73b3716e432237f9fd0152a81b18ef58026b35a02690dcffbbda886751b4e"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

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

  fails_with gcc: "5"

  def install
    args = std_cmake_args

    if OS.mac?
      # Force to link to system GLUT (see: https:cmake.orgBugview.php?id=16045)
      glut_lib = "#{MacOS.sdk_path}SystemLibraryFrameworksGLUT.framework"
      args << "-DGLUT_glut_LIBRARY=#{glut_lib}"
    end

    args << "-DBUILD_TESTING=OFF"
    args << "-DDART_BUILD_DARTPY=OFF"
    args << "-DDART_ENABLE_SIMD=OFF"

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Clean up the build file garbage that has been installed.
    rm_r Dir["#{share}docdart**CMakeFiles"]
  end

  test do
    (testpath"test.cpp").write <<~EOS
      #include <dartdart.hpp>
      int main() {
        auto world = std::make_shared<dart::simulation::World>();
        assert(world != nullptr);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{Formula["eigen"].include}eigen3",
                    "-I#{include}", "-L#{lib}", "-ldart",
                    "-L#{Formula["assimp"].opt_lib}", "-lassimp",
                    "-L#{Formula["boost"].opt_lib}", "-lboost_system",
                    "-L#{Formula["libccd"].opt_lib}", "-lccd",
                    "-L#{Formula["fcl"].opt_lib}", "-lfcl",
                    "-std=c++17", "-o", "test"
    system ".test"
  end
end