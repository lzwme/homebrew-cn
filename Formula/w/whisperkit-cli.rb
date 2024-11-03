class WhisperkitCli < Formula
  desc "Swift native on-device speech recognition with Whisper for Apple Silicon"
  homepage "https:github.comargmaxincWhisperKit"
  url "https:github.comargmaxincWhisperKitarchiverefstagsv0.9.2.tar.gz"
  sha256 "a5cf99b31bdf28df26952a1bda2d5b4decf1614784e89883bad3015a3b25be31"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6952e57de4c18e0b7260dce916c5e21c514fb7d4c53fd3a55c118542c65cf98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af09485f967ea991ff598429facc544dd2ddb95c55f41b56457cafb064183b16"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ccd010e0d26fed2f5936c0821901a6130e11097b4461d84a49e65c16d22acfe5"
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