class Sqruff < Formula
  desc "Fast SQL formatter/linter"
  homepage "https://github.com/quarylabs/sqruff"
  url "https://ghfast.top/https://github.com/quarylabs/sqruff/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "2970a5eb8e4df663ec6abcae148b19667c8bc0fd3c48a20d3eb57603b8450176"
  license "Apache-2.0"
  head "https://github.com/quarylabs/sqruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ee48774426ee4378a2f64f2c43ff20f0fa0cc5119a24e8a6c4bc22ca6d9a411"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94812d960797af5adce5456730f866d6177282578c8bc853bd66ec343e77e770"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fae3c1e05bfc6bfa1c40f0044760cae413661e14d352b431989131699fcc2923"
    sha256 cellar: :any_skip_relocation, sonoma:        "4393df5facbd60e609b45c83b43d2bcb41ebdfe78e0967cb92f0c83ae9ad8e73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31da9bc642ba7979ad98d70e5db073f3decbee3e32e77eb16bdc8ea21a3f66c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27b5ca9c671ada457f4d4ef2c30541164513a181f40b09f7fb943d03f861a905"
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