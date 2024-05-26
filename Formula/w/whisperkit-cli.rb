class WhisperkitCli < Formula
  desc "Swift native on-device speech recognition with Whisper for Apple Silicon"
  homepage "https:github.comargmaxincWhisperKit"
  url "https:github.comargmaxincWhisperKitarchiverefstagsv0.7.1.tar.gz"
  sha256 "4b13b24d3ec52e4582a8b53e06cfcab03707b7c3b86653be9f06d06fb45084a2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a424b3a167845726013f463345b55e5c4e6c7a11dddf42a6ff4941eedb43273a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dca71e4cb8e86c37b851aeecbbeda10907507062bb208fd468f15c07e2151f81"
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