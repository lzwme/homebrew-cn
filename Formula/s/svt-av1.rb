class SvtAv1 < Formula
  desc "AV1 encoder"
  homepage "https://gitlab.com/AOMediaCodec/SVT-AV1"
  url "https://gitlab.com/AOMediaCodec/SVT-AV1/-/archive/v3.1.0/SVT-AV1-v3.1.0.tar.bz2"
  sha256 "8231b63ea6c50bae46a019908786ebfa2696e5743487270538f3c25fddfa215a"
  license "BSD-3-Clause"
  head "https://gitlab.com/AOMediaCodec/SVT-AV1.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3a012b4410dd0983dfcc7306f1e58542a4eab657b0e41451e07da79c88b8f393"
    sha256 cellar: :any,                 arm64_sonoma:  "d2791a38d82f791905c2efdc047284e7e008502e36b2753d3fc34eb30ae3eb4b"
    sha256 cellar: :any,                 arm64_ventura: "7dce5f701d442ecef1257ad6c318e5ee9e7dff82aca37c00a35461ab06633167"
    sha256 cellar: :any,                 sonoma:        "96151a74c3f55dcb392a975a5fa75200acb9934c50bf4caa405d87fe4f7358db"
    sha256 cellar: :any,                 ventura:       "d70e5b35ec77099161e4f29e2fbc6d7117419187d688de1d28a843fa8b984bf1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "021a9b5d0f3147813b1e9752f7198991b43f48c692f0880b3deccd158adb1f4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e32d129e15e8b1c4c4d54f2183466c3ba7462a36b69d8b8ace31765c99d0c746"
  end

  depends_on "cmake" => :build
  depends_on "nasm" => :build

  def install
    # Features are enabled based on compiler support, and then the appropriate
    # implementations are chosen at runtime.
    # See https://gitlab.com/AOMediaCodec/SVT-AV1/-/blob/master/Source/Lib/Codec/common_dsp_rtcd.c
    ENV.runtime_cpu_detection

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-testvideo" do
      url "https://github.com/grusell/svt-av1-homebrew-testdata/raw/main/video_64x64_yuv420p_25frames.yuv"
      sha256 "0c5cc90b079d0d9c1ded1376357d23a9782a704a83e01731f50ccd162e246492"
    end

    testpath.install resource("homebrew-testvideo")
    system bin/"SvtAv1EncApp", "-w", "64", "-h", "64", "-i", "video_64x64_yuv420p_25frames.yuv", "-b", "output.ivf"
    assert_path_exists testpath/"output.ivf"
  end
end