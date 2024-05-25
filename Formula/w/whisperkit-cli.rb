class WhisperkitCli < Formula
  desc "Swift native on-device speech recognition with Whisper for Apple Silicon"
  homepage "https:github.comargmaxincWhisperKit"
  url "https:github.comargmaxincWhisperKitarchiverefstagsv0.7.0.tar.gz"
  sha256 "aa927d178b2ce6fd2f0d521c361eab306541e5850195f5706cde0d67bf441c1e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d74ea92c430d68f726cadbfcc1b871cdeca55015ac5cf817edaf652827416a85"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0274bd173d1e56be4f88a2f8773740152e1776808f11f8fd3ad0bb48013c1e3e"
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