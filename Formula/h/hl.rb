class Hl < Formula
  desc "Fast and powerful log viewer and processor"
  homepage "https://github.com/pamburus/hl"
  url "https://ghfast.top/https://github.com/pamburus/hl/archive/refs/tags/v0.33.2.tar.gz"
  sha256 "c3f40674ed7f9bf73c2a82cb99d7d6283d3fd6cdab52adefbe908a79bd057424"
  license "MIT"
  head "https://github.com/pamburus/hl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b1056e1b0d1586d39a76c97b8646fa870811facbe4b2f3fc01bbbadd77ba719d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29162114ecba30c4d92b7b980e8e663216dfbe21313a70416e437e45c9fcde37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "539a5d17a60b2626152d3db5a472098cf33cd62bb2b6d930e43eddfd6afa31a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf1c9923a738e369fc7ac7c48fbbc5da25a8307250c40e667a97791ebb374610"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5917fffd2f4f256d0874791ca75a3d69fce7a0706e9446e2b485356c33956978"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "015ec6402d0f64977fc191b8c0c0f35eec436e3f4d0f52e06eb26765406736ac"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"hl", "--shell-completions")
    (man1/"hl.1").write Utils.safe_popen_read(bin/"hl", "--man-page")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hl --version")

    (testpath/"sample.log").write <<~EOS
      time="2025-02-17 12:00:00" level=INFO msg="Starting process"
      time="2025-02-17 12:01:00" level=ERROR msg="An error occurred"
      time="2025-02-17 12:02:00" level=INFO msg="Process completed"
    EOS

    output = shell_output("#{bin}/hl --level ERROR sample.log")
    assert_equal "Feb 17 12:01:00.000 [ERR] An error occurred", output.chomp
  end
end