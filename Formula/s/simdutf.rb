class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://simdutf.github.io/simdutf/"
  url "https://ghfast.top/https://github.com/simdutf/simdutf/archive/refs/tags/v9.1.1.tar.gz"
  sha256 "ec707f17e5083999efbdaf8a9a08d35e71e955b35dbf4b8307d14a7d31e9697f"
  license any_of: ["Apache-2.0", "MIT"]
  compatibility_version 4
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b4da000554488ec398da26ff6f2c16430fa645e67d15f0804e995bfa203e28be"
    sha256 cellar: :any, arm64_tahoe:       "3b81084aeef5c84c21b1c8a8a5a53742b32dbd8dbf7b4ef0a6a839bf325881e7"
    sha256 cellar: :any, arm64_sequoia:     "cda9e6f3de9122d68ec7b9fded18777b0624e615e3809041b4bb1f794ab8a0fe"
    sha256 cellar: :any, arm64_sonoma:      "4a348075010760264c703d46be418aa3a3362838c1a617c15964693f6c13d01f"
    sha256 cellar: :any, arm64_linux:       "95dc74a074df68db99d2a361c5702c9b3a522e1c46d67bdda2f2823fd0e5d942"
    sha256 cellar: :any, x86_64_linux:      "6c5dc4edf13a9cc83676856637d8c97c60eedaa33ec1d3123c9897b3d70df44a"
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