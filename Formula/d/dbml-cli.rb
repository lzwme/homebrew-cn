class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-3.13.9.tgz"
  sha256 "f75f57714510cdb0b8ee5ba3e69a3c050f7cd1ecc12ce0af9a882ac86ebc15c7"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "0f96bc6f2206f075ab7cdc7f47c9c9ad23d2e1135eaf165b9d8224e01b9502d8"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Build an `:all` bottle by removing log file.
    rm libexec/"lib/node_modules/@dbml/cli/yarn-error.log"
  end

  test do
    sql_file = testpath/"test.sql"
    sql_file.write <<~SQL
      CREATE TABLE "staff" (
        "id" INT PRIMARY KEY,
        "name" VARCHAR,
        "age" INT,
        "email" VARCHAR
      );
    SQL

    expected_dbml = <<~SQL
      Table "staff" {
        "id" INT [pk]
        "name" VARCHAR
        "age" INT
        "email" VARCHAR
      }
    SQL

    assert_match version.to_s, shell_output("#{bin}/dbml2sql --version")
    assert_equal expected_dbml, shell_output("#{bin}/sql2dbml #{sql_file}").chomp
  end
end