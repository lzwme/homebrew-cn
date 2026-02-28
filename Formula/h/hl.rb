class Hl < Formula
  desc "Fast and powerful log viewer and processor"
  homepage "https://github.com/pamburus/hl"
  url "https://ghfast.top/https://github.com/pamburus/hl/archive/refs/tags/v0.35.4.tar.gz"
  sha256 "c89bef668256263be1d162a060e3384a0b675445afb08c4c303154aee02df257"
  license "MIT"
  head "https://github.com/pamburus/hl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77e5a22c5dffc4598804f6c6ab7bb70a171d914cb6013473959314a8d104b777"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1234ca1e20b692738fa54e1994dd64cd8adbab9918a58ff920e4a66e8e8eef0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a4fe791479004178ae082be612e258a1ef86c6daa83a3329e30e7bb3f25dda4"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a8426cb5010ada17a6375f8c8c0a7fb85003f47d4f3e73907acdc93e0f9c888"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8724d5191fe9f85c50ffc09b11de42d02223ce634b711f40cd80035f4b9cced"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d7c56df2c54916dec47ea82ee3a4303cb2d849a80140c71174a37fc75e1891e"
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