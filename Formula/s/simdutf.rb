class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://simdutf.github.io/simdutf/"
  url "https://ghfast.top/https://github.com/simdutf/simdutf/archive/refs/tags/v9.3.1.tar.gz"
  sha256 "a21dfe67e5a0f6c3589fb2efb25c8715e0c0a80e656edd500785a34f04c4a2c0"
  license any_of: ["Apache-2.0", "MIT"]
  compatibility_version 7
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d60cd6f21d96271b9270ce2a6007a0e67cd252599d88cdf1d92a30423d620e2b"
    sha256 cellar: :any, arm64_tahoe:       "200cc3b6d90cc0746040f78e40991bda44ceb975d9c0a80b0b23b96a8105bae4"
    sha256 cellar: :any, arm64_sequoia:     "309adf65ede96f9bc7a772502e3f8b35506b7f4c106510dc7dad5ddfcb59723b"
    sha256 cellar: :any, arm64_linux:       "ab5bfaaf22eed6a96b826a6f256eb7de985a874c0ff7242c6bfed38d4465b5eb"
    sha256 cellar: :any, x86_64_linux:      "3e8ac5895b095a269b47727fe731cf484e4d380ec9b6507b01fe1778178e1f9e"
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