class SvtAv1 < Formula
  desc "AV1 encoder"
  homepage "https://gitlab.com/AOMediaCodec/SVT-AV1"
  url "https://gitlab.com/AOMediaCodec/SVT-AV1/-/archive/v3.1.1/SVT-AV1-v3.1.1.tar.bz2"
  sha256 "a91a3a095cc3146697c6e46155f095492f177d95585e90fc87a5df1ee41869e2"
  license "BSD-3-Clause"
  head "https://gitlab.com/AOMediaCodec/SVT-AV1.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f4503350bb65f6d5edd242898a21b767f496094789f44da5dca548b80fe1d3ae"
    sha256 cellar: :any,                 arm64_sonoma:  "77dd90c0e18c2b3a261efee025dd6feb89076a13b381c32dd6ba2f5b00e941dd"
    sha256 cellar: :any,                 arm64_ventura: "9873398e84dc0f2857b0af232a792d399f074c25ada35f88366aad88159c61cb"
    sha256 cellar: :any,                 sonoma:        "ad01ec360f56d6cc01f85ff550b01cb0425d429663fca649725883ede6cb41fa"
    sha256 cellar: :any,                 ventura:       "5dc6a67a062093870623b1eea6830335c70232c7752bc3b498bddde02921184d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56cb7653c3778987d34fe7addb7c8516254da59ff0728e691bbf195312a3f107"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71b89043e1285f6ad2645b88b8f4925939974483939d6f476ea4b6fe69d2203a"
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