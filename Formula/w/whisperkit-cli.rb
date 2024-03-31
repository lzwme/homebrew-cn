class WhisperkitCli < Formula
  desc "Swift native on-device speech recognition with Whisper for Apple Silicon"
  homepage "https:github.comargmaxincWhisperKit"
  url "https:github.comargmaxincWhisperKit.git",
      tag:      "v0.5.0",
      revision: "61df12a322aa9ff840a46f78115ad0ad93873e2e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9854e4b469c048d5e0d45dbad3f77bed0bbd45a465c7c66feab4f0c2f86c411"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "165b77cd617e366f8c96bf005ee7e869d36ee2560fa6c4187fb3bc50134b417f"
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
    whisperkit_command = [
      "#{bin}whisperkit-cli",
      "transcribe",
      "--model",
      "tiny",
      "--download-model-path",
      "#{testpath}model",
      "--download-tokenizer-path",
      "#{testpath}tokenizer",
      "--audio-path",
      test_fixtures("test.mp3"),
      "--verbose",
    ].join(" ")
    assert_includes shell_output(whisperkit_command), "Transcription:"
  end
end