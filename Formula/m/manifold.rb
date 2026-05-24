class Manifold < Formula
  desc "Geometry library for topological robustness"
  homepage "https://github.com/elalish/manifold"
  url "https://ghfast.top/https://github.com/elalish/manifold/releases/download/v3.5.0/manifold-3.5.0.tar.gz"
  sha256 "ad75aab26438a81fc4ffdd816104753bc95f0219f325a988ea89859b5de91b78"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "aebe32718c867e0458e5992e302fb514e036fde35cf6fcd64e6353d7c9d26147"
    sha256 cellar: :any,                 arm64_sequoia: "0a699ed1cadd406c3556c058802cb8850d8c3b666c8f754427610503666d25a6"
    sha256 cellar: :any,                 arm64_sonoma:  "09e39b664ae5d408d9cec45fad6322a18af36e2778448a277f7a873d6a995c97"
    sha256 cellar: :any,                 sonoma:        "058002aa8807e559156498b38ddd49de455b8906d648d49dcf778972f0e5b406"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "628e0da7c6addd6a7365f1e246d47c5f2132357731c483fbc52309bfcf611ce4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a85bf153f32fef04b36d069b310cec189bb48f3092660c0b7a9e7bd7a9e2492"
  end

  depends_on "cmake" => :build
  depends_on "clipper2"
  depends_on "tbb"

  def install
    args = %w[
      -DMANIFOLD_DOWNLOADS=OFF
      -DMANIFOLD_PAR=ON
      -DMANIFOLD_TEST=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "extras/large_scene_test.cpp"
  end

  test do
    system ENV.cxx, pkgshare/"large_scene_test.cpp",
                    "-std=c++17", "-I#{include}", "-L#{lib}", "-lmanifold",
                    "-o", "test"
    assert_match "nTri = 91814", shell_output("./test")
  end
end