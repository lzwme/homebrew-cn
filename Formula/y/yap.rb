class Yap < Formula
  desc "On-device audio transcription using Speech.framework"
  homepage "https://github.com/finnvoor/yap"
  url "https://ghfast.top/https://github.com/finnvoor/yap/archive/refs/tags/1.1.0.tar.gz"
  sha256 "d4a3f0574779eb518e6de28f61fe5fef5aec4402bbc93119477619b18955114a"
  license "CC0-1.0"
  head "https://github.com/finnvoor/yap.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "d8923225596234f39b78a5d8dca9269748f5af3261772911b46c14d24cbe8a91"
  end

  depends_on xcode: ["26.0", :build]
  depends_on macos: :tahoe
  depends_on :macos
  uses_from_macos "swift" => [:test]

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "--product", "yap"
    bin.install ".build/release/yap"
  end

  test do
    system bin/"yap", "help"

    # SpeechTranscriber not supported on virtualized macOS
    # and yap returns an "unsupportedLocale" error if run on BrewTestBot runners
    # so we only run real audio tests if SpeechTranscriber.isAvailable returns true.
    transcriber_available = Utils.popen_read(
      "swift", "-e", "import Speech; print(SpeechTranscriber.isAvailable)"
    ).strip
    run_transcriber_tests = $CHILD_STATUS.success? && transcriber_available == "true"
    return unless run_transcriber_tests

    system bin/"yap", test_fixtures("test.mp3"), "--output-file", "test.mp3.txt"
    assert_path_exists testpath/"test.mp3.txt"
    system bin/"yap", test_fixtures("test.wav"), "--output-file", "test.wav.txt"
    assert_path_exists testpath/"test.wav.txt"
  end
end