class Manifold < Formula
  desc "Geometry library for topological robustness"
  homepage "https://github.com/elalish/manifold"
  url "https://ghfast.top/https://github.com/elalish/manifold/releases/download/v3.3.1/manifold-3.3.1.tar.gz"
  sha256 "d068189301194c986b496d0251d5f634d9b822ce4e1a8ffdc2d1dc67664a9699"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "34b49038853f4b2cd3a37911c9acac8ab76a8444548e9a25129fbec3ceb912f1"
    sha256 cellar: :any,                 arm64_sequoia: "8305bd00a01b45e1bd8457cdb37469d7b92c4b6ca4274174c42ad3fb1ccd9a00"
    sha256 cellar: :any,                 arm64_sonoma:  "293a2ad00c957b304c4339e279288779d8c1676582bc9832d2e628e212214324"
    sha256 cellar: :any,                 sonoma:        "255179fdcd8cc51fa224e371bfe784fd87fe961ea3352782698aec1fe6920a99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f5add191f016065cc61ac4eaf162b68d4e4c077f82ad4bffe7d24e6d808a00e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77cbcf1d76e2fb223eed1372f85d35da23b1f08c4afd58562811dba42d37a2e0"
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