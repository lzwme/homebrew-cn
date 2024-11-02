class WhisperkitCli < Formula
  desc "Swift native on-device speech recognition with Whisper for Apple Silicon"
  homepage "https:github.comargmaxincWhisperKit"
  url "https:github.comargmaxincWhisperKitarchiverefstagsv0.9.1.tar.gz"
  sha256 "a6bb376cdd7b9a1f1f76ec4e120e59d64562340b9d5b8731d35b760b1521d7b4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e6bf3288b5f5502b2709d2a12a17db49686c1ce21a70fcf01b60e25df2bc5c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b758ae2089dc287f3013c38426cd248b0e4a622a2a8ff3668bb375b617e22001"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2b88019a2e9f57f804120a00efd6a48d33121e56c2f10d058935be6761c3670f"
  end

  depends_on xcode: ["15.0", :build]
  depends_on arch: :arm64
  depends_on :macos
  depends_on macos: :ventura

  uses_from_macos "swift"

  def install
    system "swift", "build", "-c", "release", "--product", "whisperkit-cli", "--disable-sandbox"
    bin.install ".buildreleasewhisperkit-cli"
  end

  test do
    mkdir_p "#{testpath}tokenizer"
    mkdir_p "#{testpath}model"

    test_file = test_fixtures("test.mp3")
    output = shell_output("#{bin}whisperkit-cli transcribe --model tiny --download-model-path #{testpath}model " \
                          "--download-tokenizer-path #{testpath}tokenizer --audio-path #{test_file} --verbose")
    assert_match "Transcription of test.mp3", output
  end
end