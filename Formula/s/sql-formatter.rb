class SqlFormatter < Formula
  desc "Whitespace formatter for different query languages"
  homepage "https://sql-formatter-org.github.io/sql-formatter/"
  url "https://registry.npmjs.org/sql-formatter/-/sql-formatter-15.6.4.tgz"
  sha256 "87eed4f3a0d0b64a35ebb790593ccd4d0f2066cb05865455191f6e6ba05bb81b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "376430bf9d8477f476ceb6678de35f3679d2d7e009e62a21048d5e383b023054"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sql-formatter --version")

    (testpath/"test.sql").write <<~SQL
      SELECT * FROM users WHERE id = 1;
    SQL

    system bin/"sql-formatter", "--fix", "test.sql"
    expected_output = <<~SQL
      SELECT
        *
      FROM
        users
      WHERE
        id = 1;
    SQL

    assert_equal expected_output, (testpath/"test.sql").read
  end
end