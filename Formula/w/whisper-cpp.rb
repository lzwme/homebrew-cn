class WhisperCpp < Formula
  desc "Port of OpenAI's Whisper model in C/C++"
  homepage "https://github.com/ggerganov/whisper.cpp"
  url "https://ghproxy.com/https://github.com/ggerganov/whisper.cpp/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "088e6fcb5a38179308c4120c6ac4296918d2ea974321f6f2a062aec067c36880"
  license "MIT"
  head "https://github.com/ggerganov/whisper.cpp.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "10b69a46356e65d88efd09abe35508ca675aff3ae9c392000f93eab7ca2f0f77"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d1d8dc3b35ca4003548af911b942e6be7300544c251d6237cb550931ddebb31"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "250022722501d35c7f0ecebaf43c1e671b113307f834ca79f294b87e22fd2cdc"
    sha256 cellar: :any_skip_relocation, sonoma:         "f4bd6e460748c0d90b931bb4ae7641e99e4156c83b0944012362d6add38e5d5e"
    sha256 cellar: :any_skip_relocation, ventura:        "363b162df16a3c6e425b09059efa00615ddcb4c2ecba32624694d9562091e9c4"
    sha256 cellar: :any_skip_relocation, monterey:       "bdc0128871e213a2962bf029dd030f6268f65b5b60c6bd530f624086eeeddb51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a19aa2dee6fa206eea58a365815f3352efd2a9aa7b63e7b99ee5061f374d92d"
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