class SvtAv1 < Formula
  desc "AV1 encoder"
  homepage "https:gitlab.comAOMediaCodecSVT-AV1"
  url "https:gitlab.comAOMediaCodecSVT-AV1-archivev2.1.1SVT-AV1-v2.1.1.tar.bz2"
  sha256 "e490d8e8ef8cd1f8f814fd207590f36dc1c1eb228efec959cfea113c57797ced"
  license "BSD-3-Clause"
  head "https:gitlab.comAOMediaCodecSVT-AV1.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8c58d8fc74ad6311c234d1c0446a9d5159c4555dac50d96e43c96f4981cdf5c0"
    sha256 cellar: :any,                 arm64_ventura:  "5b7c74a40f3c7739c5c0d88b5754811594ecad3563673a0cf4c09d49058b6f16"
    sha256 cellar: :any,                 arm64_monterey: "2d24f7b92fee95cbb761bc0996ed3c3bfeea659e96d45f615336dbb3ca4fbbfe"
    sha256 cellar: :any,                 sonoma:         "e44548f6ba85bf40f7808c3a274a0e281801a2e65d42b595e1a4042696da922b"
    sha256 cellar: :any,                 ventura:        "9ccc4fbad61b3333f02d335e5824408c680976ad64e1fa2d427e908914ba82a2"
    sha256 cellar: :any,                 monterey:       "3581e27d942b8b2dadff606b6bc29139c1614a8ff88c899ff0cb9bfee15e2c71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c651f8891379b157d550b64c2e9ac1fbee5ba7478f599b37fdaa5ededeedd733"
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
    system "#{bin}SvtAv1EncApp", "-w", "64", "-h", "64", "-i", "video_64x64_yuv420p_25frames.yuv", "-b", "output.ivf"
    assert_predicate testpath"output.ivf", :exist?
  end
end