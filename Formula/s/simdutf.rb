class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://simdutf.github.io/simdutf/"
  url "https://ghfast.top/https://github.com/simdutf/simdutf/archive/refs/tags/v9.2.1.tar.gz"
  sha256 "582f9d0dcf578f6d4766fa29ea12a7f2f02bd3c6ad9e0cf35a8e0ec8478eba4b"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1
  compatibility_version 6
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b5990df2e687dbd5b2d3212adf7a5d60dc2ea7f20eb8245711f23b259f3b861a"
    sha256 cellar: :any, arm64_tahoe:       "5621579c497fe7f5f6d0c4ccf0f61d9107f319231ade4922c5fc9578f2728cb1"
    sha256 cellar: :any, arm64_sequoia:     "39b53197558ebd796c9bc4d8e9f7a0fe040cedceca9c6e448e16cebf27d98176"
    sha256 cellar: :any, arm64_linux:       "73355ee95d638fb3a61f1abeef369bd9435a3f240f3aa3e2d427084f1730bb81"
    sha256 cellar: :any, x86_64_linux:      "c326e7ae4d05162d4242b52eac9663311e5a2c5b702db58795bd4fb912b77cbb"
  end

  depends_on "aklomp-base64" => :build
  depends_on "cmake" => :build
  depends_on "icu4c@78"

  uses_from_macos "python" => :build

  deny_network_access!

  def install
    # C++20 is needed by `node`
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON
      -DCPM_LOCAL_PACKAGES_ONLY=ON
      -DPython3_EXECUTABLE=#{which("python3")}
      -DSIMDUTF_BENCHMARKS=ON
      -DSIMDUTF_CXX_STANDARD=20
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    bin.install "build/benchmarks/benchmark" => "sutf-benchmark"
  end

  test do
    system bin/"sutf-benchmark", "--random-utf8", "10240", "-I", "100"
  end
end