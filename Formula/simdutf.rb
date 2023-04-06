class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://github.com/simdutf/simdutf"
  url "https://ghproxy.com/https://github.com/simdutf/simdutf/archive/refs/tags/v3.2.7.tar.gz"
  sha256 "52db3f7fe65b2c31bec05aea1c4e2737a90c56fdf8dd17660f429a4483b2ea17"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "283c6333f827801c912c7258de47353569cee74385b968ec7085132df5d2b245"
    sha256 cellar: :any, arm64_monterey: "8076c0a03529033a8ac63431e67c6962fcb7533f132a462b93a1dfc59c982730"
    sha256 cellar: :any, arm64_big_sur:  "0c4c7ee088ed16d3d6bfe772a00534295f8c08e1b7545336ffc87907b5ce7afc"
    sha256 cellar: :any, ventura:        "f81b903ff8585159f0adde8258f05785c3a5dbf387e1eadf35845170eb9aa1d8"
    sha256 cellar: :any, monterey:       "19b6e6aa447d4afa0435eb4c36d812919d6eba7e254ff4d1723549967f915008"
    sha256 cellar: :any, big_sur:        "24f97e2acbb5e829bd14a6de4dd8b0470f91de9fc2d91376a33d8ddd7788ffc6"
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