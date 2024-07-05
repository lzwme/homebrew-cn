class Dartsim < Formula
  desc "Dynamic Animation and Robotics Toolkit"
  homepage "https:dartsim.github.io"
  url "https:github.comdartsimdartarchiverefstagsv6.14.2.tar.gz"
  sha256 "6bbaf452f8182b97bf22adeab6cc7f3dc1cd2733358543131fa130e07c0860fc"
  license "BSD-2-Clause"
  revision 1

  bottle do
    sha256                               arm64_sonoma:   "f51ee46a7e1f4bb644dad337ec05f1b371e3493ad00056e856ae18ec64270eb7"
    sha256                               arm64_ventura:  "f85b8b2d47d826f0a46df4a190467e136fed73aadbfcd1772acf194a99b8dd76"
    sha256                               arm64_monterey: "f6283a0ccc658818a39836ca7145d16d47c659bc34b6f12eea161ed1cd857e62"
    sha256                               sonoma:         "79c176a1838d1945f09d681fa793699577ad54eb9f82a106e23ca61722c9989d"
    sha256                               ventura:        "318de2f6dff8deb79fe2d98a6a98a4eb4ab78f9c3f54f2db8f25e2425e8fb823"
    sha256                               monterey:       "5368af64d629c92879db1efc47b977d38dbb3e15169e826edc5f8051bd6cae2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04747ac18422d4bb609131f1dc076dc32bbcdb5b7c7799036ea71a8866446c7b"
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