class Hl < Formula
  desc "Fast and powerful log viewer and processor"
  homepage "https://github.com/pamburus/hl"
  url "https://ghfast.top/https://github.com/pamburus/hl/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "bfc3108b10e9a18a6bcffa50388f5a61fa3fec8fbec35126994b1f4f3311ebd4"
  license "MIT"
  head "https://github.com/pamburus/hl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "125ef5fb8ad6127e2425f0231d308a7e821354f0e74b3109ea003ff06c10f082"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77911482a7a4371b6d59d4bc4e5e4040dc57fd4764e9289f740ea0529e94c46a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "880eb9dbfd7a8ef17fbb4887939bcb4c52d5530de03e67f4995ea89ab0a9bfdd"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0b0b70d1a8c9c055b79b6ddde8be69f110ab771726ce1801e797006a982422c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5dd4302438d021ddd9cee4c5c2b4c03f85754924bab4ac80ae484d3dea02d950"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbddc51331203175dc93b447836e6ea6b0444aedde0df5dfd9a05f1a088eadbd"
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