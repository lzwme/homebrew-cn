class Sqruff < Formula
  desc "Fast SQL formatter/linter"
  homepage "https://github.com/quarylabs/sqruff"
  url "https://ghfast.top/https://github.com/quarylabs/sqruff/archive/refs/tags/v0.29.2.tar.gz"
  sha256 "7eb9c1fb3a1bfa9116f89edcd4eca55138799561c5be2ed4f133682c2e6668d8"
  license "Apache-2.0"
  head "https://github.com/quarylabs/sqruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55a28f920e478e130d5d7f42034ce0105e19c96e1993a56ed456e2d4cc302ee4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26e50a716eec79765ea36e0665569ae35bd09badd113eba50214dae2b94367c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "21ffa0505da0c4e0fdc474e4a16f84825ed574937863a7abd918e7d6f0ede4bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8bc3f15023cc3ef61505907588a192d4a62c1a6c95b8773842a3faa928a0218"
    sha256 cellar: :any_skip_relocation, ventura:       "5b2318e0122b7beb421dd65ff90270ede24538aee7325970733a62448455de4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ae89d5a1aa8f4e338c4ca9b64969f85dce9f43c3de834bff44fb889c7c5821b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31305f0ab845daa7864d6bc5ad2072ec2f1039a8f0103b31849b8c440ad3b529"
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