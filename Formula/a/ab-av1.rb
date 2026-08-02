class AbAv1 < Formula
  desc "AV1 re-encoding using ffmpeg, svt-av1 & vmaf"
  homepage "https://github.com/alexheretic/ab-av1"
  url "https://ghfast.top/https://github.com/alexheretic/ab-av1/archive/refs/tags/v0.11.5.tar.gz"
  sha256 "12c835097c48216668f57f0517ed9b082553c05884cab4d1218bafc6e71cf003"
  license "MIT"
  head "https://github.com/alexheretic/ab-av1.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3fd06388570c001b60998543e35f79750281a55896304dc8bde49540b51ec37b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad1cc0a1bc3aea80ea20a0d5a3454b557be337417de8cc0ae0c44dbd2078892d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f13858df7e7065a8583e67fce84c3f626ecc3eb8fe77d9ccdaf0e6b0179567b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e3e8dbec76340cea17b799b15a826d7e76c20833734410e76d61dee862aa3bc"
    sha256 cellar: :any,                 arm64_linux:   "14572da30eaf1976cce7ad6b2000f5fd6bda24724c950fd213e4c85a1201add9"
    sha256 cellar: :any,                 x86_64_linux:  "c5565b8e6ad9f2e0f58f3258562a3f774a115d73c2c3afd3f1fc5ae72e189377"
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