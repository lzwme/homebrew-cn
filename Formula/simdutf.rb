class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://github.com/simdutf/simdutf"
  url "https://ghproxy.com/https://github.com/simdutf/simdutf/archive/refs/tags/v3.2.4.tar.gz"
  sha256 "64e78d12727d38155c35c6a60be3146575594c0ef73d79b702b73771336954ca"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "131996c5fdac3c290d2e06f38ccb3efb210a356b9c3888cd1368c8eff60b71a6"
    sha256 cellar: :any, arm64_monterey: "3c2200877d661815a605f8cb74612660fe825f63ece13d7fb0c4c27bf438420c"
    sha256 cellar: :any, arm64_big_sur:  "d2ecccf311a7160fd630e79ac969ebee03865168a22ce098dfb02c605b4e33bf"
    sha256 cellar: :any, ventura:        "fe5f4ef7b34d35ff61cbf1c3e5c591116dbb85a8758d9a8fad90884e14394578"
    sha256 cellar: :any, monterey:       "09d3445cff454a00f71083b08de2fe4033a6791223bc1703858d014e55a86346"
    sha256 cellar: :any, big_sur:        "1bdcf22c81cf40c212dbe867999f441cf51b33d9c7d9dfde9177a4bb1ac10d9a"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11" => :build
  depends_on "icu4c"
  depends_on macos: :catalina

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DBUILD_TESTING=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    bin.install "build/benchmarks/benchmark" => "sutf-benchmark"
  end

  test do
    system bin/"sutf-benchmark", "--random-utf8", "1024", "-I", "20"
  end
end