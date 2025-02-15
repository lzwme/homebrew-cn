class SqlFormatter < Formula
  desc "Whitespace formatter for different query languages"
  homepage "https://sql-formatter-org.github.io/sql-formatter/"
  url "https://registry.npmjs.org/sql-formatter/-/sql-formatter-15.4.10.tgz"
  sha256 "7197a33453d262f0a62fe28c52d9ea7e6793f68a4a9e352b5e3b622da2283ee9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f72f7d24b87e4051c9a0cdf673c00e9b718fd22e92e200ad633348b01d85ba31"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/sql-formatter"
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