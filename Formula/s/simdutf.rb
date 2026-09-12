class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://simdutf.github.io/simdutf/"
  url "https://ghfast.top/https://github.com/simdutf/simdutf/archive/refs/tags/v9.1.2.tar.gz"
  sha256 "0992cd1bcddee10424e49d6bc3ff8da02f9abc4c48033cbb1b0b41b62c727d33"
  license any_of: ["Apache-2.0", "MIT"]
  compatibility_version 4
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0d7eed901743ff965125ee3012f9afeadc6b4ed33578e5be27784345883145c6"
    sha256 cellar: :any, arm64_tahoe:       "b47b339400b8eabd33b3abaf8cdb310204c5ae24c06e804cfc7f2404d8727886"
    sha256 cellar: :any, arm64_sequoia:     "864a6ddb9f494ecaa53eea80e10e534a71c4f2f73050c8e32bb989b928c4567b"
    sha256 cellar: :any, arm64_linux:       "ae439d1736b7e2376d6f3005f04bb5e563100f0f8d634e561525482e8b702db9"
    sha256 cellar: :any, x86_64_linux:      "19b47637533afaefbd5a8a24e14713b566c88b943c1f57c91bce12dbec3b6979"
  end

  depends_on "aklomp-base64" => :build
  depends_on "cmake" => :build
  depends_on "icu4c@78"

  uses_from_macos "python" => :build

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON
      -DCPM_LOCAL_PACKAGES_ONLY=ON
      -DPython3_EXECUTABLE=#{which("python3")}
      -DSIMDUTF_BENCHMARKS=ON
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