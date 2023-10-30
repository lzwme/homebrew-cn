class WhisperCpp < Formula
  desc "Port of OpenAI's Whisper model in C/C++"
  homepage "https://github.com/ggerganov/whisper.cpp"
  url "https://ghproxy.com/https://github.com/ggerganov/whisper.cpp/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "b2e34e65777033584fa6769a366cdb0228bc5c7da81e58a5e8dc0ce94d0fb54e"
  license "MIT"
  head "https://github.com/ggerganov/whisper.cpp.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a423b0a1f92abfc6943b532974d147d669c2b2186adef609e45c8ae0aba7ab81"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba631877ce4264b21bc92059c00d7126e221eefb6c3af71817d13950943a1cfd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0477268232b8a0cac4c9bdfba2f5761f32ceeeaae2e831af384da25cce82ee26"
    sha256 cellar: :any_skip_relocation, sonoma:         "911dde991f864552eda6f9e1f02cde50b8f3553e17f97e8a2b45b11a3b027bcb"
    sha256 cellar: :any_skip_relocation, ventura:        "82e500f75ec0b6fc70637b87bd6fe9c05f69e646c93e64e9189233c4784a5522"
    sha256 cellar: :any_skip_relocation, monterey:       "9a781ea22a2d82c29109dc2fb6b510a90195bda0fe39a630560f357746bff60b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51fcf294e742b544a23228614574065af4fb37ded56050083d31b4cab7f0f23c"
  end

  def install
    system "make"
    bin.install "main" => "whisper-cpp"

    pkgshare.install ["samples/jfk.wav", "models/for-tests-ggml-tiny.bin"]
  end

  test do
    cp [pkgshare/"jfk.wav", pkgshare/"for-tests-ggml-tiny.bin"], testpath

    system "#{bin}/whisper-cpp", "samples", "-m", "for-tests-ggml-tiny.bin"
    assert_equal 0, $CHILD_STATUS.exitstatus, "whisper-cpp failed with exit code #{$CHILD_STATUS.exitstatus}"
  end
end