class Sfcgal < Formula
  desc "C++ wrapper library around CGAL"
  homepage "https://sfcgal.gitlab.io/SFCGAL/"
  url "https://gitlab.com/sfcgal/SFCGAL/-/archive/v2.3.0/SFCGAL-v2.3.0.tar.gz"
  sha256 "5f6aa1838e5ae31523ebf410cde0240b7a88d7e062b7ffff945e4fae2aaba0fa"
  license "LGPL-2.0-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "670b480cb5d2bc39b82cd44eb88036db3c5760662650f942ccdb0601fad7214e"
    sha256 cellar: :any, arm64_sequoia: "9479bc005dd3623c205bbb219050dd6d8fd4126a49eefad7763ba9da8bf1371f"
    sha256 cellar: :any, arm64_sonoma:  "2ab6ae6bdf02ffc9e14eddd124492cccc1e44ba6ff3b025bf3d127dc7c6a4af0"
    sha256 cellar: :any, sonoma:        "947e01f26a488842713b55d4b2c6c378f0518233f253bc564e47f3572f925993"
    sha256 cellar: :any, arm64_linux:   "4494d02b8b01087ff8ee0c2c8b6432f56942df2df68427d4f3bc3ed83480bb4d"
    sha256 cellar: :any, x86_64_linux:  "76fba11c983750b09a694fb1ccb933d32990cc32da98027491f8de8772e83fb8"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "boost"
  depends_on "cgal"
  depends_on "gmp"
  depends_on "mpfr"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_equal prefix.to_s, shell_output("#{bin}/sfcgal-config --prefix").strip
  end
end