class HppFcl < Formula
  desc "Extension of the Flexible Collision Library"
  homepage "https:github.comhumanoid-path-plannerhpp-fcl"
  url "https:github.comhumanoid-path-plannerhpp-fclreleasesdownloadv2.4.5hpp-fcl-2.4.5.tar.gz"
  sha256 "14ddfdecdbde323dedf988083e4929d05b5b125ec04effac3c2eec4daa099b43"
  license "BSD-2-Clause"
  head "https:github.comhumanoid-path-plannerhpp-fcl.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3e1fd03383304c60e4777a04c5f0b72aad9ba64a0607e4d6781b42a968c10a4f"
    sha256 cellar: :any,                 arm64_ventura:  "40da0df1eda5b885facebe2b530b393651af7041fc7182ed675361f8d3c76803"
    sha256 cellar: :any,                 arm64_monterey: "2268133f5e31e0e086468889d7c7eaa3ed3cf4dc348efd4355c7c07f7e171c02"
    sha256 cellar: :any,                 sonoma:         "d5c2a06095c6886688e026270770a1cd27a1d4ad69bb3365bfabef477ac054cf"
    sha256 cellar: :any,                 ventura:        "f0edc34a30de385fba5dab3badb135403015cfce64958f7604df5a346ebfef94"
    sha256 cellar: :any,                 monterey:       "177dabe2c11dc15495e1c538922525738ea6c3188cf6adb8c85fa5524364e7c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f413c2c680b31c84d46a62132842caa32ad56c13ae23230c9aa7831f4d2902b"
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