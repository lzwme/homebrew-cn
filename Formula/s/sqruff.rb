class Sqruff < Formula
  desc "Fast SQL formatter/linter"
  homepage "https://github.com/quarylabs/sqruff"
  url "https://ghfast.top/https://github.com/quarylabs/sqruff/archive/refs/tags/v0.34.1.tar.gz"
  sha256 "2c12017dfe6c5572cb004793b7190924092b34691dd46b73b57d0b253421abba"
  license "Apache-2.0"
  head "https://github.com/quarylabs/sqruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f5884cded2f740563ccf01ee7350a03e6801d77d44624d4e652e6a4a157668d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01d62480c42774e679cab1ce6d3ba2702ca27393de012a7f06323d35fa6b0c88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6587cce8f3e0eb63d872a94ca40630eb16174b448c3889c4625b7de53c43e36"
    sha256 cellar: :any_skip_relocation, sonoma:        "b90d94b3118383ef5fb622aeb49c45d3dadef89f5d4ffd0ee99e262b92a7fcf6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f433617cece4f9069ce3b749c1847c1b004907e5a545a6e22ecfd5bebdc8f8b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60d576f84712af1e75cab14ec57f8aefca86d8dc22d160af9ec39b5e1b1ca0bf"
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