class WhisperkitCli < Formula
  desc "Swift native on-device speech recognition with Whisper for Apple Silicon"
  homepage "https:github.comargmaxincWhisperKit"
  url "https:github.comargmaxincWhisperKitarchiverefstagsv0.6.0.tar.gz"
  sha256 "90f5427f4223caded729897153f03296f81b1c178a0dd335e8666cba150c03ff"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e00628843aafa260e65775a8a7796e0d35356293cd0c87f98de85948bb56bc7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c33de58d35b6310a54c1bd9faad296bdb7105b5b7f8f66a0a9f5955ba39db094"
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