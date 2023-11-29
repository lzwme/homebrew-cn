class HppFcl < Formula
  desc "Extension of the Flexible Collision Library"
  homepage "https://github.com/humanoid-path-planner/hpp-fcl"
  url "https://ghproxy.com/https://github.com/humanoid-path-planner/hpp-fcl/releases/download/v2.4.0/hpp-fcl-2.4.0.tar.gz"
  sha256 "15b5f1d6fe98fd3bf175913821296c14b31ce1822ef303d9c6dff8ad2fefc733"
  license "BSD-2-Clause"
  head "https://github.com/humanoid-path-planner/hpp-fcl.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1adf10373a869072db91be2cf3efd6dfd4e082c8b62a36e92d65b6098a53c1d4"
    sha256 cellar: :any,                 arm64_ventura:  "930e84fb48b17e05f54389e1e2915962358ce967f1820b7f8c4973c6d62caf20"
    sha256 cellar: :any,                 arm64_monterey: "c00de10ea0d053e71d0ce42c7cf77dfe9e93e4878a8af9899905d9111ecba7fd"
    sha256 cellar: :any,                 sonoma:         "7d72225cc6d5287c5c716bcb22a56f61bd9f2bcdf287df0ef1de69f91e0b8d90"
    sha256 cellar: :any,                 ventura:        "42ef35e83f4446b7ecab8162733e99c4261bed63e190e478f8aadb27c8f154a7"
    sha256 cellar: :any,                 monterey:       "f5a93a0a07603b867c4c4a6ee736f0cee278ffd0050fb447faf1fc5549e2814f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d7084105805b72c6aa95a00c1ef9830dcd0819fddfff5f11b9a580c8e1f7074"
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