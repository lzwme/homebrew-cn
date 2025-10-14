class Pinocchio < Formula
  desc "Efficient and fast C++ library implementing Rigid Body Dynamics algorithms"
  homepage "https://stack-of-tasks.github.io/pinocchio"
  url "https://ghfast.top/https://github.com/stack-of-tasks/pinocchio/releases/download/v3.8.0/pinocchio-3.8.0.tar.gz"
  sha256 "aa4664d95a54af7197354a80f5ad324cb291b00593886b78dd868b1fd13636ca"
  license "BSD-2-Clause"
  revision 2
  head "https://github.com/stack-of-tasks/pinocchio.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_tahoe:   "ad59d8f8645c1fe910aef054a362dc911d445655a04c360acef7ee6d80ccacae"
    sha256                               arm64_sequoia: "0a1ca75e54973052a1ca1c6dfee6e75adec52017c43a211472bac1436b56ad21"
    sha256                               arm64_sonoma:  "380a922baf90a9c088bd60b55cf4dd6bbaa7b45e56f4a725767c1792181ef2e0"
    sha256 cellar: :any,                 sonoma:        "32d270cd511a9e56c7a0c82fad9bb455d5374dd8124567a8a9f4d3d4ff2994a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af875d4f6244dbd34a2bc777c15b85d86d4f1823190d749fb3f7da10d1f6139b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af9b95baee413bd3831563b83fc4e3be81d353244d8cfe8ab87ff69713f23a74"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkgconf" => :build

  depends_on "boost"
  depends_on "boost-python3"
  depends_on "coal"
  depends_on "console_bridge"
  depends_on "eigen"
  depends_on "eigenpy"
  depends_on "python@3.14"
  depends_on "urdfdom"

  on_macos do
    depends_on "octomap"
  end

  # Workaround for Boost 1.89.0
  # TODO: Report upstream
  patch :DATA

  def python3
    "python3.14"
  end

  def install
    if build.head?
      system "git", "submodule", "update", "--init"
      system "git", "pull", "--unshallow", "--tags"
    end

    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXECUTABLE=#{which(python3)}",
                    "-DBUILD_UNIT_TESTS=OFF",
                    "-DBUILD_WITH_COLLISION_SUPPORT=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system python3, "-c", <<~PYTHON
      import pinocchio
      model = pinocchio.Model()
      data = model.createData()
      assert model.nv == 0 and model.nq == 0
    PYTHON
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 67dd06db..5fbe52be 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -286,7 +286,7 @@ if(BUILD_WITH_EXTRA_SUPPORT)
   message(STATUS "Found Qhull.")
 endif()

-set(BOOST_REQUIRED_COMPONENTS filesystem serialization system)
+set(BOOST_REQUIRED_COMPONENTS filesystem serialization)

 set_boost_default_options()
 export_boost_default_options()