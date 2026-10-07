class Sqruff < Formula
  desc "Fast SQL formatter/linter"
  homepage "https://github.com/quarylabs/sqruff"
  url "https://ghfast.top/https://github.com/quarylabs/sqruff/archive/refs/tags/v0.41.0.tar.gz"
  sha256 "88742d67a5e54d88b3d19918fff317c870ecea59bfc637942d13a74db97a6b4c"
  license "Apache-2.0"
  head "https://github.com/quarylabs/sqruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "890e1ba281bd13c9d58fe8d02e3ee8e74cb443ad1bbc65e1aeb1cd9f26ebf1a8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c37022740fba7684b80961baabae4c10b927a1524435c9e91261924b0cdeb129"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0c3d7bd939ab6106252f3d8a9b9bea5f316d29bd5a26f83ffa668e04f9d02cc6"
    sha256 cellar: :any,                 arm64_linux:       "95423a7684990335153dd8db88ba84645859ea784bf4fa5da28ff5043d55ae45"
    sha256 cellar: :any,                 x86_64_linux:      "677f5e535f81c8e2a92aa0197900b3795260eab568b8fbf46c1f9348c5c03af3"
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