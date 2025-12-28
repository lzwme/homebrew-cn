class Sqruff < Formula
  desc "Fast SQL formatter/linter"
  homepage "https://github.com/quarylabs/sqruff"
  url "https://ghfast.top/https://github.com/quarylabs/sqruff/archive/refs/tags/v0.30.1.tar.gz"
  sha256 "6cdd5190a33342963a8c970b62c11e50cd04e9386e3a2601af0e3fcd286bc05a"
  license "Apache-2.0"
  head "https://github.com/quarylabs/sqruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e9860d4124f3b951ba21aaa578db76baf47264fdf96206b0fd6585a6acbe007"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "616e665fe747d49d23bc652bf174829387cb75f4ad144ef202b34ae1d9bdd462"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5fe182f357eefce9f0197c8dafb2f2529c5d3be64380025af1168019c545395b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ded45e6803d16c2ac1ad60eaba9bf26945a154756f0888729938f7acd7f47ad0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72c3c84baad6c47aefdb860263f765adc6f2ee3c5090ab05e0cb26e7cd70b4de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6858b7d5baae89960a1de644f4524c5eede1257e65db5dcd1994867acd520293"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--bin", "sqruff", *std_cargo_args(path: "crates/cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sqruff --version")

    assert_match "AL01:	[aliasing.table]", shell_output("#{bin}/sqruff rules")

    (testpath/"test.sql").write <<~EOS
      SELECT * FROM user JOIN order ON user.id = order.user_id;
    EOS

    output = shell_output("#{bin}/sqruff lint --format human #{testpath}/test.sql 2>&1")
    assert_match "All Finished", output
  end
end