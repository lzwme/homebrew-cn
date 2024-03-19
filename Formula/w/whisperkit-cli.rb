class WhisperkitCli < Formula
  desc "Swift native on-device speech recognition with Whisper for Apple Silicon"
  homepage "https:github.comargmaxincWhisperKit"
  url "https:github.comargmaxincWhisperKit.git",
      tag:      "v0.4.0",
      revision: "59cb8516c708e3e2f18198002600026b5a1135ca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6abaf4c40cab1995dfb0ca8f91fd61c7099f69ea1d4159a81a4d05ac9c55c297"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4a373194bfcc4304ff3763763f8de3d3ceb62a57ec7f27433cf3e1d45cd51df2"
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