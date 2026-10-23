class Sqruff < Formula
  desc "Fast SQL formatter/linter"
  homepage "https://github.com/quarylabs/sqruff"
  url "https://ghfast.top/https://github.com/quarylabs/sqruff/archive/refs/tags/v0.43.0.tar.gz"
  sha256 "431a0fae3a184860fa0ac436cc0a9c14fa48cabc141f5993eeaed8fa27b80597"
  license "Apache-2.0"
  head "https://github.com/quarylabs/sqruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a51a02acdb8c18da358321cb8346c8a77598d1a8a0e35f1e8bdd4d24cb7fac0d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "14aff0e2a579172ec5d9e7cac1727b6aa0d37c405fb46a8defed690a82d4ab76"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "657bc709665355996d3f9085d156b3b1e0f671748c915eb5638cbbf60c5378ca"
    sha256 cellar: :any,                 arm64_linux:       "afe9052f7b020b2bcb47935ba63f7c0bb38e49203edc3452671ea24f0c4fa9bc"
    sha256 cellar: :any,                 x86_64_linux:      "5d885b8f78b7de567f6a9ca669fdbb6573e5b0942c074b9e34d08172ffb1044b"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", "--bin", "sqruff", *std_cargo_args(path: "crates/cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sqruff --version")

    assert_match "AL01:	[aliasing.table]", shell_output("#{bin}/sqruff rules")

    (testpath/"test.sql").write <<~SQL
      SELECT * FROM user JOIN order ON user.id = order.user_id;
    SQL

    output = shell_output("#{bin}/sqruff lint --format human #{testpath}/test.sql 2>&1")
    assert_match "All Finished", output
  end
end