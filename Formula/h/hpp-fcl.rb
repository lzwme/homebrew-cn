class HppFcl < Formula
  desc "Extension of the Flexible Collision Library"
  homepage "https://github.com/humanoid-path-planner/hpp-fcl"
  url "https://ghproxy.com/https://github.com/humanoid-path-planner/hpp-fcl/releases/download/v2.3.6/hpp-fcl-2.3.6.tar.gz"
  sha256 "17b7aa65d942168b44ca4ad17be28454aef50729867034021d7789a122dce6a7"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/humanoid-path-planner/hpp-fcl.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9c979d5cfa38e91c9ceba35e1ff22fdf120c57f0110b2b487bd481e9d553ea3a"
    sha256 cellar: :any,                 arm64_ventura:  "0357cf3cbe5d390f1b522544d34dc43f769bf41ef2610215d0254dfab74c090e"
    sha256 cellar: :any,                 arm64_monterey: "eaf32066fba97c74646360a3e5e2ed22b7520b36e4de7d6047afa301077a2cfc"
    sha256 cellar: :any,                 sonoma:         "4041d9ac1b2281e8cd7ff1eece54d1ca56728faf38599e479969b3efe8e1f8b3"
    sha256 cellar: :any,                 ventura:        "ced5b0043d61d3950e999a98232bea374107543b766d207dea837083802b61dc"
    sha256 cellar: :any,                 monterey:       "b0bf47d12a19211f3efa995a791e6aa44e7c52b68f2b3598adc4c35e80827098"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11d87805ba57abaf948fa9d5f48495037fd84ad48c275b177dd2abc03beee52c"
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