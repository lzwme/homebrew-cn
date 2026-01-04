class Hl < Formula
  desc "Fast and powerful log viewer and processor"
  homepage "https://github.com/pamburus/hl"
  url "https://ghfast.top/https://github.com/pamburus/hl/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "0fec353d81b4e9c9a25896df3792d9a31a29b145bb070c43bf105ad16045802d"
  license "MIT"
  head "https://github.com/pamburus/hl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e32a27de09454914ba9a4de62c63d613934634dd291c491ee0550e09e48b598"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da65bf9cd54f744f2bbaf380a90f92403aaa6b22bb136315737c4d075045cf20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b6ab9bd074412b07d6ce1a9c22df898b853a72086eb6be9f10ff5da479ff346"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a3649b5ec53f7b3b12a61d5232f0cbe8650b1dfbf807bf4e0eda186e5ab4e2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbd0194b2bb8d333fbb9245744fb39a03d5b730e9a493d4d509606890751843b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9562107437fcd32403e9066221b0c5b2b4f02989f56d82d1e5228e40b1c1ab10"
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