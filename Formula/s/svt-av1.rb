class SvtAv1 < Formula
  desc "AV1 encoder"
  homepage "https:gitlab.comAOMediaCodecSVT-AV1"
  url "https:gitlab.comAOMediaCodecSVT-AV1-archivev3.0.1SVT-AV1-v3.0.1.tar.bz2"
  sha256 "f1d1ad8db551cd84ab52ae579b0e5086d8a0b7e47aea440e75907242a51b4cb9"
  license "BSD-3-Clause"
  head "https:gitlab.comAOMediaCodecSVT-AV1.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f2c57586c7e9424b894d23ff735ed9a9979872a243e04964c980d6667131aca5"
    sha256 cellar: :any,                 arm64_sonoma:  "684176968c86f82c3c099ed8371ecc7764556b9b5a098ded4df6d473447dfa8d"
    sha256 cellar: :any,                 arm64_ventura: "d402791bdc3b1c81d11829c7ddb3b31cffefb5467143a0c599bad37808581b16"
    sha256 cellar: :any,                 sonoma:        "9805dfe1b36ee2f89682c19f6008562f9ad9d4b96c53607281056c83424c5415"
    sha256 cellar: :any,                 ventura:       "622952ca1a70c125b62420a57d53e3f9b921c177444c5175ef6c14c1029f67ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "454ffac36a950f5bb54fca98e51c052100837413369d0ef4e53fbb0fd2e7c122"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97172cec2603dcc637b21a845dc6b14f86cbfe9abd299c59b04d65979c9bf4fe"
  end

  depends_on "cmake" => :build
  depends_on "nasm" => :build

  # Match the version of cpuinfo specified in https:gitlab.comAOMediaCodecSVT-AV1-blobmastercmakecpuinfo.cmake
  resource "cpuinfo" do
    url "https:github.com1480c1cpuinfoarchivee649baaa95efeb61517c06cc783287d4942ffe0e.tar.gz"
    sha256 "f89abf172b93d75a79a5456fa778a401ab2fc4ef84d538f5c4df7c6938591c6f"
  end

  def install
    # Features are enabled based on compiler support, and then the appropriate
    # implementations are chosen at runtime.
    # See https:gitlab.comAOMediaCodecSVT-AV1-blobmasterSourceLibCodeccommon_dsp_rtcd.c
    ENV.runtime_cpu_detection

    (buildpath"cpuinfo").install resource("cpuinfo")

    cd "cpuinfo" do
      args = %W[
        -DCPUINFO_BUILD_TOOLS=OFF
        -DCPUINFO_BUILD_UNIT_TESTS=OFF
        -DCPUINFO_BUILD_MOCK_TESTS=OFF
        -DCPUINFO_BUILD_BENCHMARKS=OFF
        -DCMAKE_INSTALL_PREFIX=#{buildpath}cpuinfo-install
        -DCMAKE_POSITION_INDEPENDENT_CODE=ON
      ] + std_cmake_args.reject { |arg| arg.start_with? "-DCMAKE_INSTALL_PREFIX=" }

      system "cmake", "-S", ".", "-B", "cpuinfo-build", *args
      system "cmake", "--build", "cpuinfo-build"
      system "cmake", "--install", "cpuinfo-build"
    end

    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DUSE_CPUINFO=SYSTEM
      -Dcpuinfo_DIR=#{buildpath"cpuinfo-installsharecpuinfo"}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-testvideo" do
      url "https:github.comgrusellsvt-av1-homebrew-testdatarawmainvideo_64x64_yuv420p_25frames.yuv"
      sha256 "0c5cc90b079d0d9c1ded1376357d23a9782a704a83e01731f50ccd162e246492"
    end

    testpath.install resource("homebrew-testvideo")
    system bin"SvtAv1EncApp", "-w", "64", "-h", "64", "-i", "video_64x64_yuv420p_25frames.yuv", "-b", "output.ivf"
    assert_path_exists testpath"output.ivf"
  end
end