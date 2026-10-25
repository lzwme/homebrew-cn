class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://simdutf.github.io/simdutf/"
  url "https://ghfast.top/https://github.com/simdutf/simdutf/archive/refs/tags/v9.3.2.tar.gz"
  sha256 "d92a0a4ce216dcebf18af20fed7ea7279fa535683f790fdaeed39827a234f567"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1
  compatibility_version 7
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ea02e459d2107976603360a08d0ae3a267430588ebd9bc4fc7f6107255f66eba"
    sha256 cellar: :any, arm64_tahoe:       "1986c6b992a3f97a4c44eb44a0c227fd54ac247515e59f2bdcb2d95b122f5d5d"
    sha256 cellar: :any, arm64_sequoia:     "19a0c05574ce252a9864e4d68d4f633741e8194456dce240791573c012367c66"
    sha256 cellar: :any, arm64_linux:       "e2bffc98d4297d9d6e968a4cd54bad8b8bc1d9e4178d5bcd0c0e74bd49a0440d"
    sha256 cellar: :any, x86_64_linux:      "c2bccbd6568e70db47fea43243d1e11e5ef813564b9894721b1e10599d685003"
  end

  depends_on "aklomp-base64" => :build
  depends_on "cmake" => :build
  depends_on "icu4c@79"

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