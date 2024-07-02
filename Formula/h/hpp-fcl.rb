class HppFcl < Formula
  desc "Extension of the Flexible Collision Library"
  homepage "https:github.comhumanoid-path-plannerhpp-fcl"
  url "https:github.comhumanoid-path-plannerhpp-fclreleasesdownloadv2.4.4hpp-fcl-2.4.4.tar.gz"
  sha256 "cae32b6beb6a93896bf566453e6897606763219cebb3dbfaa229a1e4214b542a"
  license "BSD-2-Clause"
  revision 3
  head "https:github.comhumanoid-path-plannerhpp-fcl.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6b63fc586d4255653545fc0753d5dd51e4fcb1f0753dbc40aa148674b22a8539"
    sha256 cellar: :any,                 arm64_ventura:  "c295799ea98b2839cc3662ed309d7520d4866277443a35ce6377d1975334e86c"
    sha256 cellar: :any,                 arm64_monterey: "fc6e4b43d84b2611e0d94a8905fdf31bf1ba81f8aaa371c313ee8bafdcd634fc"
    sha256 cellar: :any,                 sonoma:         "dfa8aff216c8268265a0eb08c1d91a503c8bcf228c939b7f96d762d2b33280cf"
    sha256 cellar: :any,                 ventura:        "d974cbe53b552f6fcfd57f5e46e802ad669fd39f87ffe18f5bab4c9fadc49a34"
    sha256 cellar: :any,                 monterey:       "381ca407d3bb1efb8bef9f3f4ac4f3944252c674fd7a967275bb88c9ff54fcec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd86cdf77c7993595ebe17b1ba46a1f1ff80445c954fbec27adacb6a2fc899e5"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "assimp"
  depends_on "boost"
  depends_on "boost-python3"
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