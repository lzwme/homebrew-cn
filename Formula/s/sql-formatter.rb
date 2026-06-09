class SqlFormatter < Formula
  desc "Whitespace formatter for different query languages"
  homepage "https://sql-formatter-org.github.io/sql-formatter/"
  url "https://registry.npmjs.org/sql-formatter/-/sql-formatter-15.8.1.tgz"
  sha256 "10b423ce2f706e6e416903b33a3b27b361f473ec58fe59ca5a2e8c49db1164ba"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4e1051939fc6096386b861bd5b82ba8e11e275749f049c965c29ea8f0b4804ca"
  end

  depends_on "node"

  def install
    ENV["NPM_CONFIG_FORCE"] = "1"
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