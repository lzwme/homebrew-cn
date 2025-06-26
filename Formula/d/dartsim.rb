class Dartsim < Formula
  desc "Dynamic Animation and Robotics Toolkit"
  homepage "https:dartsim.github.io"
  url "https:github.comdartsimdartarchiverefstagsv6.15.0.tar.gz"
  sha256 "bbf954e283f464f6d0a8a5ab43ce92fd49ced357ccdd986c7cb4c29152df8692"
  license "BSD-2-Clause"
  revision 3

  bottle do
    sha256                               arm64_sequoia: "08cf5126898fd7f596cccffd2a0ce99c204357d6ccf8e093ad14b2ef013f71f3"
    sha256                               arm64_sonoma:  "9f219a59641b0d1342cbb1cf56e2b176af0b9eaad21962c871089bd074817fe4"
    sha256                               arm64_ventura: "317d051f7b314ade07bbd8d093cbd2085b9bb1d7d79fa2aaf95e591cd2698fff"
    sha256                               sonoma:        "7d048de514214568a192e23735b6daf555e1bf32cd662a5ad3b278baa8310e0d"
    sha256                               ventura:       "e5beb4c71d2eb2e7eb8438316bf5fe94bdfe7d9d258d7b02ac3072197343fdda"
    sha256                               arm64_linux:   "73d102f2bac6599cf0da600e936ccdb6513bb04d9599d0eac504813217e64701"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fd1bfc80c63ec633749e1e74c171342f4103db609a8304c75151c3dd31c4c2e"
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
      # Force to link to system GLUT (see: https:cmake.orgBugview.php?id=16045)
      glut_lib = "#{MacOS.sdk_path}SystemLibraryFrameworksGLUT.framework"
      args << "-DGLUT_glut_LIBRARY=#{glut_lib}"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Clean up the build file garbage that has been installed.
    rm_r Dir["#{share}docdart**CMakeFiles"]
  end

  test do
    (testpath"test.cpp").write <<~CPP
      #include <dartdart.hpp>
      int main() {
        auto world = std::make_shared<dart::simulation::World>();
        assert(world != nullptr);
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-I#{Formula["eigen"].include}eigen3",
                    "-I#{include}", "-L#{lib}", "-ldart",
                    "-L#{Formula["assimp"].opt_lib}", "-lassimp",
                    "-L#{Formula["libccd"].opt_lib}", "-lccd",
                    "-L#{Formula["fcl"].opt_lib}", "-lfcl",
                    "-std=c++17", "-o", "test"
    system ".test"
  end
end