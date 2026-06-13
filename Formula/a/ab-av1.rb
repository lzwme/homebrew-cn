class AbAv1 < Formula
  desc "AV1 re-encoding using ffmpeg, svt-av1 & vmaf"
  homepage "https://github.com/alexheretic/ab-av1"
  url "https://ghfast.top/https://github.com/alexheretic/ab-av1/archive/refs/tags/v0.11.3.tar.gz"
  sha256 "c146fe1e1fd32b52a74157f49ae6b38642ea88933079b1a3a14afc39a500c3fd"
  license "MIT"
  head "https://github.com/alexheretic/ab-av1.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f51c04ef7ecc8d9f40f8df065f2f994d09008d860f41dbb38aee3d5e5adcb9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8b90f7a6ca41b24fc7de58f57a5afcb3243eedc1dc795e6e911b96447cb971d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9cf5d6a56ce0203cf435f7a1c6cd495e0cf2ff283bf16fe0c15f41ce5afc7bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "207305c5a36426157efbcfcb87fb7ceb919ed8fb9df49175506114663e7995d7"
    sha256 cellar: :any,                 arm64_linux:   "52290f5b1fb2de7e3d727911289a4f7d6dbe70bb0f01c83076af750a8ba396d6"
    sha256 cellar: :any,                 x86_64_linux:  "b354499696de9545ad236ca58d3bc8ae74abee89de410d5857a9f0e0e98a4d1c"
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