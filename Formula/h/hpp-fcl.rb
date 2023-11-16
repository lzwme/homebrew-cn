class HppFcl < Formula
  desc "Extension of the Flexible Collision Library"
  homepage "https://github.com/humanoid-path-planner/hpp-fcl"
  url "https://ghproxy.com/https://github.com/humanoid-path-planner/hpp-fcl/releases/download/v2.3.7/hpp-fcl-2.3.7.tar.gz"
  sha256 "b5588c0661bd90a979ad98984cdbf9f5af57a983f1354bc375fd1966d633735d"
  license "BSD-2-Clause"
  head "https://github.com/humanoid-path-planner/hpp-fcl.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "feb06516fceb864aa2304a458c338fcc531a50e5d37d64215b9da05d2768fea3"
    sha256 cellar: :any,                 arm64_ventura:  "9400b37145376ce4ea6d0b9c72c3553ad9828acd01d0916c6779a82efaa4b2c1"
    sha256 cellar: :any,                 arm64_monterey: "c0f0e531f17bb570142e8978a4c3eef4b2e8b124b5400e3a879e6dd97ac2713a"
    sha256 cellar: :any,                 sonoma:         "981a2ac4fb05b9daf9694eea24e7eeea0b601f6164500c5a2736c31de054d98e"
    sha256 cellar: :any,                 ventura:        "0a89115eec46949ba4555bef15a4a90831a32f7a7d159b9b1c27a1a87441a6e7"
    sha256 cellar: :any,                 monterey:       "1e5afe36aa0fca4b639e6f397bfa1c3805e0408dfc4ea5be6863f196f4371e6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26feb8ce19155bc385848421563e1e1394d2b5242d6a5dc2660da4c3caad4ba5"
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