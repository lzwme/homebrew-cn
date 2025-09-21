class WhisperkitCli < Formula
  desc "Swift native on-device speech recognition with Whisper for Apple Silicon"
  homepage "https://github.com/argmaxinc/WhisperKit"
  url "https://ghfast.top/https://github.com/argmaxinc/WhisperKit/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "191db947fb7219ef4e68188d8ab58a32cd0da7542badedc480089afa37f14ecf"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f4d70ab8aac4adae190a73fd0877a9be12e9ab9e1a97918f59c09bbd1fdc872"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3b8d2e7edbbbaebe36cbcd3c1403edec0e698a24bae2560d37d6b40e8a3b703"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d2fc834aca630f85b37c543aed47bc5eb736b12cb3f984035034631411bdab4"
  end

  depends_on xcode: ["15.0", :build]
  depends_on arch: :arm64
  depends_on :macos
  depends_on macos: :ventura

  uses_from_macos "swift"

  def install
    system "swift", "build", "-c", "release", "--product", "whisperkit-cli", "--disable-sandbox"
    bin.install ".build/release/whisperkit-cli"
    generate_completions_from_executable(bin/"whisperkit-cli", "--generate-completion-script")
  end

  test do
    mkdir_p "#{testpath}/tokenizer"
    mkdir_p "#{testpath}/model"

    test_file = test_fixtures("test.mp3")
    output = shell_output("#{bin}/whisperkit-cli transcribe --model tiny --download-model-path #{testpath}/model " \
                          "--download-tokenizer-path #{testpath}/tokenizer --audio-path #{test_file} --verbose")
    assert_match "Transcription of test.mp3", output
  end
end