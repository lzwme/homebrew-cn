class WhisperkitCli < Formula
  desc "Swift native on-device speech recognition with Whisper for Apple Silicon"
  homepage "https://github.com/argmaxinc/WhisperKit"
  url "https://ghfast.top/https://github.com/argmaxinc/WhisperKit/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "7078b55be09ef4b4c1d6274fe5a533afc3327572553f5069ff08c55ef30146b7"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "14e8eb98c98b0baf9f0359d813158894895832e9b0f8457cd53d5b95f3ceae98"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a2ad5e3f32ffff068ff94a906d52642dc2aeb360ca8472f1aaf312708b55aa4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f192a742700595743f7788d99389970f85c4127d57a90de7c5de3e778d4dbfc1"
  end

  depends_on xcode: ["15.0", :build]
  depends_on arch: :arm64
  depends_on :macos
  depends_on macos: :ventura

  uses_from_macos "swift"

  def install
    ENV["BUILD_ALL"] = "1"
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