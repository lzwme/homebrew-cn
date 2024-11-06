class WhisperkitCli < Formula
  desc "Swift native on-device speech recognition with Whisper for Apple Silicon"
  homepage "https:github.comargmaxincWhisperKit"
  url "https:github.comargmaxincWhisperKitarchiverefstagsv0.9.3.tar.gz"
  sha256 "299f79d5b30ca174dadff2f0b206e09efcd0da558fecf7c8720f535339cedf24"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14d2bada32ae712fef38ee3b624150a7620caa3fa81e53800b043c7928f3251f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b25a08ffba61aa78e08ba63137168356bb4ec36940148cb240fb4d93d50c0f6a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9dd32de15180ec589fcb96f8ca2391a9209b13db6dbe66803adbcca605adafe8"
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