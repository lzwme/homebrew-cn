class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://github.com/simdutf/simdutf"
  url "https://ghproxy.com/https://github.com/simdutf/simdutf/archive/refs/tags/v4.0.4.tar.gz"
  sha256 "a29581bc3dc610c6d767602a5b48e27863a4e3c8eca6ed92425aeaf766344dc9"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "98505c4f319f791cefceeb10a683c821dd4b404d47c5550522499e17040ffd3a"
    sha256 cellar: :any, arm64_ventura:  "32d2f3ef1f3b54a3df4e121fadc08fcb29d6abc548f0d4e3ded03c2895298369"
    sha256 cellar: :any, arm64_monterey: "236042f7c5cfd55e115a5aceedefc1fddfbfde5f94daa8b8ed208944e77a4c21"
    sha256 cellar: :any, sonoma:         "382308348db8e6d8baf10535efd86cb4c88bf521a8ac1d79514db1007402d243"
    sha256 cellar: :any, ventura:        "2123d8de7f8e5ce8aad3bb256442bc599c4e12c2da1db19bae4246faedee4172"
    sha256 cellar: :any, monterey:       "19b5c1ed66be86e7a17179f2113cf49459545c1fc34110b3c35e6ea452290564"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11" => :build
  depends_on "icu4c"
  depends_on macos: :catalina

  def install
    args = %w[
      -DSIMDUTF_BENCHMARKS=ON
      -DBUILD_TESTING=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    bin.install "build/benchmarks/benchmark" => "sutf-benchmark"
  end

  test do
    system bin/"sutf-benchmark", "--random-utf8", "1024", "-I", "20"
  end
end