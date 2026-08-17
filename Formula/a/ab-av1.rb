class AbAv1 < Formula
  desc "AV1 re-encoding using ffmpeg, svt-av1 & vmaf"
  homepage "https://github.com/alexheretic/ab-av1"
  url "https://ghfast.top/https://github.com/alexheretic/ab-av1/archive/refs/tags/v0.11.6.tar.gz"
  sha256 "8f1a4c151a70a92afb0c03e248d4ab27872bae3e11a64723ae08f918a352cd53"
  license "MIT"
  head "https://github.com/alexheretic/ab-av1.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3abc15e807efdc9969212ec944a430b48eb466213f512bc1e4718675b41e80aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f30dd5e749006ba164dbd58bd49beba72998875234863d4c46f4de9daff9a603"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f56b7ba0548b91de0856b9db725f1008b615dd6d9334ea45862f57c8d10285d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "becaf86080b1f1d3e0a1abb7dfa831f374ce80539fc540dcc8f9c58dfdd95fea"
    sha256 cellar: :any,                 arm64_linux:   "6416d25eea523b806b424006c44d8166b01a074a96e870b35079b515c353bd8c"
    sha256 cellar: :any,                 x86_64_linux:  "692ff0c7e04f00e2ef737dbfa00c1315e6f20a7da2a7749fbe93ed5d1e98e63d"
  end

  depends_on "rust" => :build
  depends_on "ffmpeg"

  deny_network_access! [:postinstall, :test]

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"ab-av1", "print-completions", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ab-av1 --version")

    # Create a 5 second test MP4 (same as ffmpeg test) as the test fixture is too minimal
    system Formula["ffmpeg"].bin/"ffmpeg", "-filter_complex", "testsrc=rate=1:duration=5", "test.mp4"

    system bin/"ab-av1", "auto-encode", "-i", "test.mp4", "-o", testpath/"test.av1.mp4"
    assert_path_exists testpath/"test.av1.mp4"
  end
end