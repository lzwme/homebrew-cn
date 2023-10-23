class Mapcrafter < Formula
  desc "Minecraft map renderer"
  homepage "https://mapcrafter.org"
  url "https://ghproxy.com/https://github.com/mapcrafter/mapcrafter/archive/v.2.4.tar.gz"
  sha256 "f3b698d34c02c2da0c4d2b7f4e251bcba058d0d1e4479c0418eeba264d1c8dae"
  license "GPL-3.0"
  revision 9

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ac7eef67debaadc5962317b020c729af5f5598e5f7ac6818e47cb38814248739"
    sha256 cellar: :any,                 arm64_ventura:  "eab67b9a569b873e0caf36097acd63f26536b0e5277816e2546fd94b6e6cfbd6"
    sha256 cellar: :any,                 arm64_monterey: "7283b931a4ed1861d6cf179a8363f5a9559e72bdcfa6d104988abe7a41c8b89a"
    sha256 cellar: :any,                 sonoma:         "86d70b83d4bb841e7036f8de5ce82147ee35f025cb28212b619b3b6b20f2c79c"
    sha256 cellar: :any,                 ventura:        "bb7a1e2f790a248680fa80ced4bcaa3de40cf0c03ab5ad9cfa4b45de926aa8e7"
    sha256 cellar: :any,                 monterey:       "81bbded934bc26e4de2db7b7cfa4d44bf1a893a7c80bf911e4ecd8c55a5e6bca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7ed13bf91340907ab2f3728a80f4d9109d884cc1b4925e3a71df2baeefc9232"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "jpeg-turbo"
  depends_on "libpng"

  def install
    ENV.cxx11

    args = std_cmake_args
    args << "-DJPEG_INCLUDE_DIR=#{Formula["jpeg-turbo"].opt_include}"
    args << "-DJPEG_LIBRARY=#{Formula["jpeg-turbo"].opt_lib/shared_library("libjpeg")}"

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    assert_match(/Mapcrafter/,
      shell_output("#{bin}/mapcrafter --version"))
  end
end