class Dartsim < Formula
  desc "Dynamic Animation and Robotics Toolkit"
  homepage "https:dartsim.github.io"
  url "https:github.comdartsimdartarchiverefstagsv6.14.3.tar.gz"
  sha256 "a71be3b40a5b2afaf3b9cae2e79d320eddbf803bb11ab3b42c7e689c85ede7ba"
  license "BSD-2-Clause"

  bottle do
    sha256                               arm64_sonoma:   "b4e4f4cf73a7681c351d1b22c37708074a869406f18baae786453cbc2ed6366a"
    sha256                               arm64_ventura:  "00290cb3c7aac96f6f8930884211cfa1f0e465b1fdf040b98b967c5f09d5973f"
    sha256                               arm64_monterey: "8032bec2192c28c2c9b39032de753ef527a93460a63b1b8fc5168f0cf4b47b1c"
    sha256                               sonoma:         "d7a634cf6d5802305999be113e95aca2d493b95bc8f06c9b5913bd1c8fd774e1"
    sha256                               ventura:        "3c6b384baa3d6311ba34794c78eb15564ac5188776f5370bd5c60a9bbe6149e6"
    sha256                               monterey:       "1a8db81e8dc0ff58df33ddd37bdc53f1c5933afc9e23527740c0674a65c77ec6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89ad194d394645dae085e67769fdb48bacf04d177f724c28fd6a9451fc11d530"
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