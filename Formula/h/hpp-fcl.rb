class HppFcl < Formula
  desc "Extension of the Flexible Collision Library"
  homepage "https://github.com/humanoid-path-planner/hpp-fcl"
  url "https://ghproxy.com/https://github.com/humanoid-path-planner/hpp-fcl/releases/download/v2.3.6/hpp-fcl-2.3.6.tar.gz"
  sha256 "17b7aa65d942168b44ca4ad17be28454aef50729867034021d7789a122dce6a7"
  license "BSD-2-Clause"
  revision 2
  head "https://github.com/humanoid-path-planner/hpp-fcl.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a030f08255136350398ed06336eefb9a5c8a7d24fe9539b864177d68fc11750f"
    sha256 cellar: :any,                 arm64_ventura:  "4ef0d5dad3f138a75fa4e06554f5c4e0f6d936dd990f0376c9eedfd854c32260"
    sha256 cellar: :any,                 arm64_monterey: "c5e998f3c21652bd42b98ea5293fc4b355d83df3200d4a93a7af837164ef9e3d"
    sha256 cellar: :any,                 sonoma:         "d216a424bfadb9bd09e8bcef93d802a1828768495c4e3ae94bc8e2333c83a656"
    sha256 cellar: :any,                 ventura:        "cc851918c433dfff3f80a064c70fedd84d919b9e8ce1d7f3fdd19dd984a4fc78"
    sha256 cellar: :any,                 monterey:       "b4fba46c4fd8964167ab3b1044a649f2accc4e464c2ab07ae46a861edad0e655"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1edaca5f2ade555d073d9f021aa52b8695cc934dc53aad5e6d20e73a88609334"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "python-lxml" => :build
  depends_on "python-setuptools" => :build
  depends_on "assimp"
  depends_on "boost"
  depends_on "eigen"
  depends_on "eigenpy"
  depends_on "octomap"
  depends_on "python@3.12"

  def python3
    "python3.12"
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