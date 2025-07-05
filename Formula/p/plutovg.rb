class Plutovg < Formula
  desc "Tiny 2D vector graphics library in C"
  homepage "https://github.com/sammycage/plutovg"
  url "https://ghfast.top/https://github.com/sammycage/plutovg/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "8aa9860519c407890668c29998e8bb88896ef6a2e6d7ce5ac1e57f18d79e1525"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ac156e2c915c6512ff71be37db603ed4fe32329ee5074ed867fee3fd59fd7069"
    sha256 cellar: :any,                 arm64_sonoma:  "c7296dca832620899ced5f5752f32405b9db14bcb972c9cea0abae21dfd13952"
    sha256 cellar: :any,                 arm64_ventura: "987a6642fd71f6594e1af68980b4f3ecca034cc7a0fbb02824b666e4cfd2c0e1"
    sha256 cellar: :any,                 sonoma:        "adae6b93c4dc216886d41269c758800efcf3da303c88dca1cf2438b0750924e6"
    sha256 cellar: :any,                 ventura:       "53072481855f74f313530d64e6ab0f21af5bc188b48becb60de1627782b1dfb8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9b79f59f1df5754b7c031892e998e02aac551653ef94fdf9518cd072b0ce0e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdde75991f4603eddaf7249b9b7387c7f605451ede7622ce3b67518b8d202350"
  end

  depends_on "cmake" => :build

  def install
    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DPLUTOVG_BUILD_EXAMPLES=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    (pkgshare/"examples").install "examples/smiley.c"
  end

  test do
    system ENV.cc, pkgshare/"examples/smiley.c", "-o", "smiley", "-I#{include}/plutovg", "-L#{lib}", "-lplutovg"
    system testpath/"smiley"
    assert File.size("smiley.png").positive?
  end
end