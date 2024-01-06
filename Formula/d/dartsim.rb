class Dartsim < Formula
  desc "Dynamic Animation and Robotics Toolkit"
  homepage "https:dartsim.github.io"
  url "https:github.comdartsimdartarchiverefstagsv6.13.1.tar.gz"
  sha256 "d3792b61bc2a7ae6682b6d87e09b5d45e325cb08c55038a01e58288ddc3d58d8"
  license "BSD-2-Clause"
  revision 1

  bottle do
    sha256                               arm64_sonoma:   "5f77ea121a8cad5f99c6daff6bbaded977e2fb13162ebc57857a960e34c1eefa"
    sha256                               arm64_ventura:  "11071cc93829cc7aa3a3f24f391e50e5d4a1f49cd83188dc5e9647b6f98bb6bf"
    sha256                               arm64_monterey: "8c6086339404f3247dc194efec8377f94172186e0753815fec3754fe64f6a5a0"
    sha256                               sonoma:         "bb4dfe3cf76a97faa410727c66d428953fbb93f1afc3dd593c3f6695622365f8"
    sha256                               ventura:        "bda0b2cefd9c80038e40a2af53d4dc5f313ba966ebddb88c134af1ef73dd302f"
    sha256                               monterey:       "0693a91c0fcf837eedccbb9240a2469a5676d7313d6f46abbad60ecedbe15599"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe738bc59a94ad2ec66e3372e8ba1c85ab5b827a82e8196f68f317c07742293c"
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
    ENV.cxx11
    args = std_cmake_args

    if OS.mac?
      # Force to link to system GLUT (see: https:cmake.orgBugview.php?id=16045)
      glut_lib = "#{MacOS.sdk_path}SystemLibraryFrameworksGLUT.framework"
      args << "-DGLUT_glut_LIBRARY=#{glut_lib}"
    end

    mkdir "build" do
      system "cmake", "..", *args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
      system "make", "install"
    end

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