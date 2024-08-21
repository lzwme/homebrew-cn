class SvtAv1 < Formula
  desc "AV1 encoder"
  homepage "https:gitlab.comAOMediaCodecSVT-AV1"
  url "https:gitlab.comAOMediaCodecSVT-AV1-archivev2.2.0SVT-AV1-v2.2.0.tar.bz2"
  sha256 "9ebeda4602f9a3f851670e1a1cf922e05f44eef0d8f582f78c53e544c575e978"
  license "BSD-3-Clause"
  head "https:gitlab.comAOMediaCodecSVT-AV1.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "98db6b12e6b922b2e8a0e24195c383f0668cc2bf9f637ca8c4ea69141711ce98"
    sha256 cellar: :any,                 arm64_ventura:  "4744c8914f5f89cd8b048b9119dd9c0fe0c371e8850de05d7b2101e8b7a7588b"
    sha256 cellar: :any,                 arm64_monterey: "4aa7748722b78dfe58acca51833a2c5576ad79e84c7c9b790356aa19380da951"
    sha256 cellar: :any,                 sonoma:         "8da41e565be3ae7bbd2373120f1e891b158e2a7c6405a16cb122eadc7cbfa941"
    sha256 cellar: :any,                 ventura:        "bee4bf235dbe1cb6d4efb94ac2aef6aa07db87d254f6411278d6532a3b306558"
    sha256 cellar: :any,                 monterey:       "e82f0119fcaa62a8d554788b47c166f27fbf4b92d3ac2fecec7af4a2c4ff760d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0534aec9dbbb704e3e2673601857ea6b5e647fea64f82ac57d07fd58ca739692"
  end

  depends_on "cmake" => :build
  depends_on "nasm" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
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
    assert_predicate testpath"output.ivf", :exist?
  end
end