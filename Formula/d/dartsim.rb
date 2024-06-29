class Dartsim < Formula
  desc "Dynamic Animation and Robotics Toolkit"
  homepage "https:dartsim.github.io"
  url "https:github.comdartsimdartarchiverefstagsv6.14.1.tar.gz"
  sha256 "07bc1442a80abc03b2c1984bdb9b5843446047ac6a37c18b834533c871631fde"
  license "BSD-2-Clause"

  bottle do
    sha256                               arm64_sonoma:   "7779dcce35f01f3b15d6a8930a2d07625aa11cb1c85945d79978a9ed9706b215"
    sha256                               arm64_ventura:  "de5c250bf8954cd209bb81662128fb51e95099c68a56785e7d9cbfff4418ec56"
    sha256                               arm64_monterey: "352b4fad937f3f64662fbdf3a5f6041714d9b2b2146cdabb9f36d643fb9b64bc"
    sha256                               sonoma:         "82dccf2d11ba35b7ead2e79301b825035eeb0faa35cc2c1c81fd093de4fbc288"
    sha256                               ventura:        "bfbd4e61c0eb0ed64499418f21e478a47de24c20650defad57f1ac827cc0cfec"
    sha256                               monterey:       "20d0d79e266415546e4a8c7dc17a3d4533b72642a44d482d88be3bc365b94132"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ccb008e0ac76a4f735a4c28e03b3f2be8aae998241bb1f6b7e27e061ad7a73dd"
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
  depends_on "ode"
  depends_on "open-scene-graph"
  depends_on "spdlog"
  depends_on "tinyxml2"
  depends_on "urdfdom"

  uses_from_macos "python" => :build

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