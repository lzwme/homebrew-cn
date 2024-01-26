class HppFcl < Formula
  desc "Extension of the Flexible Collision Library"
  homepage "https:github.comhumanoid-path-plannerhpp-fcl"
  url "https:github.comhumanoid-path-plannerhpp-fclreleasesdownloadv2.4.0hpp-fcl-2.4.0.tar.gz"
  sha256 "15b5f1d6fe98fd3bf175913821296c14b31ce1822ef303d9c6dff8ad2fefc733"
  license "BSD-2-Clause"
  revision 1
  head "https:github.comhumanoid-path-plannerhpp-fcl.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "22e839437257724f6d0714da18ff883fbd19d78d2b91079c9d1b1ca9a7c4391e"
    sha256 cellar: :any,                 arm64_ventura:  "123a6049266412479ae0e0addea2cdbb77b7e0b7d095d89aad1ff2bb1c4bf51f"
    sha256 cellar: :any,                 arm64_monterey: "f1103b434c974b0c8c9302ada18e0f57596a13a22921d9f94bd079072c1cd2c4"
    sha256 cellar: :any,                 sonoma:         "6e466fffe44183614f955693efd154fdbf2345aca9616a7bb70bf5dd58089abe"
    sha256 cellar: :any,                 ventura:        "22a911183d4f14802bf2e471cd12039dea19e57c47406ee17e557556bb156136"
    sha256 cellar: :any,                 monterey:       "acef454d6e95a8061c525633a133e9e023d3dad2c2395bf20325b5ba70f55703"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e76850b9cfe2a9db462aecfb9a59bb9248816311511c3e27d99cef87c571522"
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
    ENV.prepend_path "PYTHONPATH", Formula["eigenpy"].opt_prefixLanguage::Python.site_packages(python3)
    ENV.prepend_path "Eigen3_DIR", Formula["eigen"].opt_share"eigen3cmake"

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