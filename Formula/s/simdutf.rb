class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://simdutf.github.io/simdutf/"
  url "https://ghfast.top/https://github.com/simdutf/simdutf/archive/refs/tags/v7.7.1.tar.gz"
  sha256 "3b119d55c47196f6310f5b7b300563e6f2789b7de352536809438a3de1eb4432"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "15a24f1bd7ceb620adbcf52aeeabf6b0585428a483440019dc1dd413698519d2"
    sha256 cellar: :any,                 arm64_sequoia: "7ca69ab8016f865aee416a6df477afca1f5c058a27b6bd73bba530da29db02ec"
    sha256 cellar: :any,                 arm64_sonoma:  "5fba7a09e89107626cbe24925de490abdd0c7805e01c66d5e25a3c61a7882ad8"
    sha256 cellar: :any,                 sonoma:        "21cbe2aaa14307d482a5fdc6c4498de7721e4e2e71ec6aca037be8c7186e0730"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7152b183d4e48fb85b79442c539fc4cd18774738c555b7bb8e1b5039b21f0659"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e133be72a6b98b5092cfeb3f0e06a5d9365672aeb139d6ec96114a9224e2ef43"
  end

  depends_on "cmake" => :build
  depends_on "icu4c@78"

  uses_from_macos "python" => :build

  resource "base64" do
    url "https://ghfast.top/https://github.com/aklomp/base64/archive/refs/tags/v0.5.2.tar.gz"
    sha256 "723a0f9f4cf44cf79e97bcc315ec8f85e52eb104c8882942c3f2fba95acc080d"

    livecheck do
      url "https://ghfast.top/https://raw.githubusercontent.com/simdutf/simdutf/v#{LATEST_VERSION}/benchmarks/base64/CMakeLists.txt"
      regex(/VERSION\s+(\d+(?:\.\d+)+)/)
    end
  end

  def install
    (buildpath/"base64").install resource("base64")

    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON
      -DFETCHCONTENT_SOURCE_DIR_BASE64=#{buildpath}/base64
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