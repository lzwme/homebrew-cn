class Sqruff < Formula
  desc "Fast SQL formatter/linter"
  homepage "https://github.com/quarylabs/sqruff"
  url "https://ghfast.top/https://github.com/quarylabs/sqruff/archive/refs/tags/v0.36.1.tar.gz"
  sha256 "16be8a8f65ecd6ee9af10884b69b07683a41abd715df5946e571af1b1788248f"
  license "Apache-2.0"
  head "https://github.com/quarylabs/sqruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f3f3c7f2166ec4a05eeccf2577743773963a2c421f9969dcd92f234dd2d58d4d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c57568df02d81fa0c391a38559d264b3b7075c035a8e675d3f5fc6ae209d040"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "434b05ddd78cca1b3949a9bf33c17f5529e52a71528f9bc7faaa3c2ed13dd434"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4a5f422746bf5cc00bb47fe06eb9f02b1a8bcf4d73c821879aa4a17462ecd93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dac9367774703f1cd3d4191e0b28c9370923ccb80f449f69af7278017b39392e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8db362df98af4495de614bf920aee029ce0d85c4116a47841d2fd63590658929"
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