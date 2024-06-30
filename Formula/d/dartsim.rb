class Dartsim < Formula
  desc "Dynamic Animation and Robotics Toolkit"
  homepage "https:dartsim.github.io"
  url "https:github.comdartsimdartarchiverefstagsv6.14.2.tar.gz"
  sha256 "6bbaf452f8182b97bf22adeab6cc7f3dc1cd2733358543131fa130e07c0860fc"
  license "BSD-2-Clause"

  bottle do
    sha256                               arm64_sonoma:   "13675f61990e33b4878b22e02685b0db1515b649b547fd609697166863d3d684"
    sha256                               arm64_ventura:  "02ccd208a65a048a45b04203c4bd48a3d8de436bfa11bf2229397fa2fcebcdcd"
    sha256                               arm64_monterey: "62874e2140eb3c1a66c8e77bebccf96b2acee547e4193db2dc4e0d93f3d238ec"
    sha256                               sonoma:         "32ada69b69e6e842b41d9febe45f9a5a62848ad9ea5faf8ab12bc41610d2ddf3"
    sha256                               ventura:        "8d7b93baec18a9a6aed22391ba0f0ac73457a8814829423527016a6ce3670694"
    sha256                               monterey:       "31acc24eda41a46f9b54a4e86a2c5a85b5ea7e737b3c492566634df62ad3a32f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f4c7764c5a8f15d18408fe1f76f1efdf880de753762e5f159bd826e3bcc2098"
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