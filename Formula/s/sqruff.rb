class Sqruff < Formula
  desc "Fast SQL formatter/linter"
  homepage "https://github.com/quarylabs/sqruff"
  url "https://ghfast.top/https://github.com/quarylabs/sqruff/archive/refs/tags/v0.28.1.tar.gz"
  sha256 "bdcb9e391e486f0033c5c2323fd1c9fe2c088dfac5cb2dde28d630c7ae0ab438"
  license "Apache-2.0"
  head "https://github.com/quarylabs/sqruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c90c208bc3f975a596d9ab6a26a9db115b59e1141094d974165607f1f8553107"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cbeabd961cfda49c43606876c6f04a3de7cb8dcc74e3674035f05238260a6df0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "54a7f57bb419b477d1f45d6923c0c7c63ed041300fa3ebf68ac78e3f82f26ebc"
    sha256 cellar: :any_skip_relocation, sonoma:        "02d685b66688ecc99a72d8460795ed8af1a1fe44a757aee7c71e182cd8561136"
    sha256 cellar: :any_skip_relocation, ventura:       "89c0a6f757e3a97a06fae2ec7f51a10f13b7955f4ab68c6694c34a2133fd17d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21e184555b1e7f63bdc0e2256989466a3931930351220ae234e80a0e947e9f61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f555fc71b3051f67ab85f088164df13b8003b695122d7e467f6b8a3ac9a919c"
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