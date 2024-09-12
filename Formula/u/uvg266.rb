class Uvg266 < Formula
  desc "Open-source VVCH.266 encoder"
  homepage "https:github.comultravideouvg266"
  url "https:github.comultravideouvg266archiverefstagsv0.8.1.tar.gz"
  sha256 "9a2c68f94a1105058d1e654191036423d0a0fcf33b7e790dd63801997540b6ec"
  license "BSD-3-Clause"
  head "https:github.comultravideouvg266.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "8aad1b0d383ca8ecbc1ff05759906c85de0bbcbdf8dca93529e92a6d81cd5c54"
    sha256 cellar: :any,                 arm64_sonoma:   "2e1d62a8487ecb14e1b585c0a7e4b6d3a59ee1a9c2a1ead291697968c1b6eb55"
    sha256 cellar: :any,                 arm64_ventura:  "aeee7925bcfdc18d227a1d911489a03abd2f5ca434336c9da4b308516641d1dc"
    sha256 cellar: :any,                 arm64_monterey: "b958ad1e7e6fa2607fc592db623418c2a7125d6bd7d75b247fe8c6d1fbb5b4ab"
    sha256 cellar: :any,                 sonoma:         "1ff7b317c2ef872de0f794eb448e26cf4b1569352b2dac1e041357756d94b3da"
    sha256 cellar: :any,                 ventura:        "9219b51849b23154d86aec45505cc450e83833a14b8c5ecf32cec6fc889a4096"
    sha256 cellar: :any,                 monterey:       "5b0ac26a3a6a6162769cd3d08d7eeb2fc43ad4bfdab0905e6e0044ef8fa73c95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2b2fc85f72c8d371bd32609a2723478c4c5f7575e3337827b5991c5b91f498d"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-videosample" do
      url "https:samples.mplayerhq.huV-codecslm20.avi"
      sha256 "a0ab512c66d276fd3932aacdd6073f9734c7e246c8747c48bf5d9dd34ac8b392"
    end
    testpath.install resource("homebrew-videosample")

    system bin"uvg266", "-i", "lm20.avi", "--input-res", "16x16", "-o", "lm20.vvc"
    assert_predicate testpath"lm20.vvc", :exist?
  end
end