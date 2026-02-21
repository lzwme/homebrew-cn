class AbAv1 < Formula
  desc "AV1 re-encoding using ffmpeg, svt-av1 & vmaf"
  homepage "https://github.com/alexheretic/ab-av1"
  url "https://ghfast.top/https://github.com/alexheretic/ab-av1/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "c856121c7fbca93a89e7a6af8fe6ae024ce4c7ace74e3214a621876fcbc4cc78"
  license "MIT"
  head "https://github.com/alexheretic/ab-av1.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e82748aa99ea04f984fadded9302861abc1982ea85c084f1c92850bf3b3d9cc6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62218c9dc327476f9b6794d20e455514e71d15ce0e22c21bf6f6f1c0c6a487f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ebb952f9652df0d5390edc2c3ef24035928ae6e7ed3c17566785705caf506634"
    sha256 cellar: :any_skip_relocation, sonoma:        "3dfcb17fe8e702c7389f710c43fbd986f4907079a1592c75bd79f81202e358ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "100b29115ab3f4a725911881c0c39fdb0e597c29186b0d9dd66f7229aef09d2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fea5a781fb7296446a39c17817e02c69b46f344f5179af3ae00ddbe545a3b79"
  end

  depends_on "rust" => :build
  depends_on "ffmpeg"

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"ab-av1", "print-completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ab-av1 --version")

    system bin/"ab-av1", "encode", "-i", test_fixtures("test.mp4"), "--crf", "32", "-o", testpath/"test.av1.mp4"
    assert_path_exists testpath/"test.av1.mp4"
  end
end