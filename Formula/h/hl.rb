class Hl < Formula
  desc "Fast and powerful log viewer and processor"
  homepage "https://github.com/pamburus/hl"
  url "https://ghfast.top/https://github.com/pamburus/hl/archive/refs/tags/v0.35.1.tar.gz"
  sha256 "54048a390ef7762d0b2bfac8941fe91bb195d17d461faaf4414fc704d128f187"
  license "MIT"
  head "https://github.com/pamburus/hl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b75bcfa5c48c914718b2d29a047776730a691bab9380367e4c207a477845f2f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49d60913e45acc7302c331dc0acc1c69970816ae7be36bb98eaa25e9272df113"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "894219b960d8eaf737e214b704f38449927438078ff42cec093e37285980c17d"
    sha256 cellar: :any_skip_relocation, sonoma:        "285cd75e14cc4bb679537996f5fffd1913dccfeda62121f3d482a1bd68eaa63b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e99acd922f053639a2b65cdf899ed620de1f5affa747a7f5f00732110f308d73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "531be33fc17a7c1f57fa613a7519e7707283de144e00d2387478395aef539888"
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