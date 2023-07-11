class Vvdec < Formula
  desc "Fraunhofer Versatile Video Decoder"
  homepage "https://github.com/fraunhoferhhi/vvdec"
  url "https://ghproxy.com/https://github.com/fraunhoferhhi/vvdec/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "a388bef01a4bf865f13357e69f2009b933ec647da0f707a41dd6be156a4ae8c1"
  license "BSD-3-Clause-Clear"
  head "https://github.com/fraunhoferhhi/vvdec.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2f80f7a627d4476176703107616488064ddb349ca9f07b664643de3139ba01f1"
    sha256 cellar: :any,                 arm64_monterey: "db8e6ac87e1e4508166b59512f3e70d74fe341d6293da069968b9f6ce0837118"
    sha256 cellar: :any,                 arm64_big_sur:  "e570bf3acc8abc9d0fe79791a3842c292a3fed0b592d3cf13c8a37f072a3b160"
    sha256 cellar: :any,                 ventura:        "14f96310269c211cbdc061198ec1c31ee9b9dc44e099f1f50677b76a98e13e5e"
    sha256 cellar: :any,                 monterey:       "e33168bd6349cc98fc52a7abec525342ed0a01c70ae4935652ff7e594f13f405"
    sha256 cellar: :any,                 big_sur:        "586f3e0c38c6f5175ce867febc27ec717daa2a25278e1ce433fd951607a6235c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88ead6701d8a759dd56b78c656561e6051de696b9307fdfe61cf89e3a037096b"
  end

  depends_on "cmake" => :build

  resource("homebrew-test-video") do
    url "https://archive.org/download/testvideo_20230410_202304/test.vvc"
    sha256 "753261009b6472758cde0dee2c004ff712823b43e62ec3734f0f46380bec8e46"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
           "-DBUILD_SHARED_LIBS=1",
           "-DVVDEC_INSTALL_VVDECAPP=1",
           *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource("homebrew-test-video").stage testpath
    system bin/"vvdecapp", "-b", testpath/"test.vvc", "-o", testpath/"test.yuv"
    assert_predicate testpath/"test.yuv", :exist?
  end
end