class SvtAv1 < Formula
  desc "AV1 encoder"
  homepage "https://gitlab.com/AOMediaCodec/SVT-AV1"
  url "https://gitlab.com/AOMediaCodec/SVT-AV1/-/archive/v1.8.0/SVT-AV1-v1.8.0.tar.bz2"
  sha256 "a7a8940a310a975ea953397ccb5b4167daf06e5e933ada6610fcb5db99491054"
  license "BSD-3-Clause"
  head "https://gitlab.com/AOMediaCodec/SVT-AV1.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "59062bea60a8ac03f9b239939b3b7f92d2ddf1d8b0c7143834cc673b91dca778"
    sha256 cellar: :any,                 arm64_ventura:  "ddec39fbcf4561792a4ead740f2f2ae2a69231988531046ac9e9f1688ab0fb19"
    sha256 cellar: :any,                 arm64_monterey: "36a4ef44f160ee790a4639729e1b9dbe88e2acdb79e9139d5343acaa4c35c53c"
    sha256 cellar: :any,                 sonoma:         "868eb71c8dd4c5925881de05d5a846450acf8cf3ce925448ea2d781f1558c6cc"
    sha256 cellar: :any,                 ventura:        "98959b573d5d6c3ef5005ad0b8204480b351c7a9aead83a0797feabc5bf8e9fc"
    sha256 cellar: :any,                 monterey:       "99dd96ce21075d725cb1eff353cf1c76138a73d4cd1965ccf19ae86a9b25e451"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3544edf1ca04a297d704a26aaddbc3f9ea623080cc9bcf9a3d7f8829fe9441ab"
  end

  depends_on "cmake" => :build

  on_intel do
    depends_on "yasm" => :build
  end

  resource "homebrew-testvideo" do
    url "https://github.com/grusell/svt-av1-homebrew-testdata/raw/main/video_64x64_yuv420p_25frames.yuv"
    sha256 "0c5cc90b079d0d9c1ded1376357d23a9782a704a83e01731f50ccd162e246492"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    testpath.install resource("homebrew-testvideo")
    system "#{bin}/SvtAv1EncApp", "-w", "64", "-h", "64", "-i", "video_64x64_yuv420p_25frames.yuv", "-b", "output.ivf"
    assert_predicate testpath/"output.ivf", :exist?
  end
end