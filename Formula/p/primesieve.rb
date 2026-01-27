class Primesieve < Formula
  desc "Fast C/C++ prime number generator"
  homepage "https://github.com/kimwalisch/primesieve"
  url "https://ghfast.top/https://github.com/kimwalisch/primesieve/archive/refs/tags/v12.12.tar.gz"
  sha256 "1a94574552f67c9ef45d89a435510c2c9bd1b93c6097509cf8834167c2b486ee"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d191e9293f272211aecf4d4ce6601fdcd7981f624096e882bacd6b92cb90fd39"
    sha256 cellar: :any,                 arm64_sequoia: "3f51ae4b8538ad6f85fd7f6df2ac09a4ecd8d22c3d0369a562a9179886fb8d3c"
    sha256 cellar: :any,                 arm64_sonoma:  "5e8105a0281f490f84f19e644a771be5564748f62499a970cb60c48dc2715632"
    sha256 cellar: :any,                 sonoma:        "2858e187b4d18e313243d842e4001a490382d7d19854fd80cfa179a79b939864"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36f43bf915880257be79af0df6ba7488873f92589f69316d3063fb2fe59271ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09ad0650aa9f4f71b41251be7128f067b81a562e0db7e53507cacb0d1bf7cb00"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"primesieve", "100", "--count", "--print"
  end
end