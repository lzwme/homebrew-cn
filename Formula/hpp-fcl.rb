class HppFcl < Formula
  desc "Extension of the Flexible Collision Library"
  homepage "https://github.com/humanoid-path-planner/hpp-fcl"
  url "https://ghproxy.com/https://github.com/humanoid-path-planner/hpp-fcl/releases/download/v2.3.2/hpp-fcl-2.3.2.tar.gz"
  sha256 "5bfec5610756885bbd107fd63aa3157bd3ca05e9e31aeb6437debc4bc11df207"
  license "BSD-2-Clause"
  head "https://github.com/humanoid-path-planner/hpp-fcl.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b912a96a7989e0018b82d65b207e89ff9ac3bee7f9060a0ad1b2cfb3c1272a7a"
    sha256 cellar: :any,                 arm64_monterey: "b480d590b0f3bccc5892060c09619c3696f417b6e9a53e35581360993e8d0d5b"
    sha256 cellar: :any,                 arm64_big_sur:  "84ec7cff094d9e926e0e1c5ec33af6747b7b04caa0f36d7e32a0c9a3cc53d019"
    sha256 cellar: :any,                 ventura:        "f04b744084067adb4b9fa297dba3ca4e9b247cade8d339a0be52a532789142f3"
    sha256 cellar: :any,                 monterey:       "1dfac1b12c5de026c459942662f35a75ae9f6fa21b0100e78dd465ccf0c953b2"
    sha256 cellar: :any,                 big_sur:        "4c15c114423dc3216eb0e532132084ce2feb28fb8a8b67833e0327dd8a1740a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53fab42c8d360479c8c0606a0d6b446e50f930153d359ce759d52349fc7e221d"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "assimp"
  depends_on "boost"
  depends_on "eigen"
  depends_on "eigenpy"
  depends_on "octomap"
  depends_on "python@3.11"

  def python3
    "python3.11"
  end

  def install
    ENV.prepend_path "PYTHONPATH", Formula["eigenpy"].opt_prefix/Language::Python.site_packages(python3)
    ENV.prepend_path "Eigen3_DIR", Formula["eigen"].opt_share/"eigen3/cmake"

    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXECUTABLE=#{which(python3)}",
                    "-DBUILD_UNIT_TESTS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system python3, "-c", <<~EOS
      import hppfcl
      radius = 0.5
      sphere = hppfcl.Sphere(0.5)
      assert sphere.radius == radius
    EOS
  end
end