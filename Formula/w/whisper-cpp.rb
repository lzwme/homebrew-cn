class WhisperCpp < Formula
  desc "Port of OpenAI's Whisper model in C/C++"
  homepage "https://github.com/ggerganov/whisper.cpp"
  url "https://ghproxy.com/https://github.com/ggerganov/whisper.cpp/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "ccf17e3283bcde3d09d333889528f3494e196f8a173d5023fec068a0dfae8f76"
  license "MIT"
  head "https://github.com/ggerganov/whisper.cpp.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a22020c7bce3aec87e6a54e6410e04527ff7fb24822d8b3da6e6766a222012fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aaa114a46d06ee8cdaefbe42083bf8a5da6f9b44c46158db9096a2c8a67f4fe3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "103ba7e7a10c73084d1c47b3786f63004b25a00bb0803c032d3e9764b478b469"
    sha256 cellar: :any_skip_relocation, sonoma:         "3739a49588b069452cc595ca742a6965787982a2395252d7c338003f4c207f06"
    sha256 cellar: :any_skip_relocation, ventura:        "668a3a2a2fae6b60ee177549141e93fbb9c68ba7f6f6c86bc7f34bc0796fcb5b"
    sha256 cellar: :any_skip_relocation, monterey:       "4d423c77786c83c7f382a2af98ea75b20f16475090d835b62837cd19d735d4e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dcc97f4a4b353332f6a8c87a6c4276b91eaf21b0e134ae7b096b28ed18a9ba51"
  end

  def install
    system "make"
    bin.install "main" => "whisper-cpp"

    pkgshare.install ["samples/jfk.wav", "models/for-tests-ggml-tiny.bin", "ggml-metal.metal"]
  end

  test do
    cp [pkgshare/"jfk.wav", pkgshare/"for-tests-ggml-tiny.bin", pkgshare/"ggml-metal.metal"], testpath

    system "#{bin}/whisper-cpp", "samples", "-m", "for-tests-ggml-tiny.bin"
    assert_equal 0, $CHILD_STATUS.exitstatus, "whisper-cpp failed with exit code #{$CHILD_STATUS.exitstatus}"
  end
end