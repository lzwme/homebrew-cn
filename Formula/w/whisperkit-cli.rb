class WhisperkitCli < Formula
  desc "Swift native on-device speech recognition with Whisper for Apple Silicon"
  homepage "https://github.com/argmaxinc/WhisperKit"
  url "https://ghfast.top/https://github.com/argmaxinc/WhisperKit/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "2f707839f4defac728614bae9151e9da545ddfbf0383d0f60c9753af8642adad"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5fff8d29341d2f1c2c116f194c5e6b571bac7211a61a07c22c9b70154581dad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed3e7684af48d7ae6368f6d0b05537da7d99094f5cc090c19d397c41f832c271"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a6094192caccbd0ff3f9caab690e97f548201d5af8b64ef8de6773ead8822a4"
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