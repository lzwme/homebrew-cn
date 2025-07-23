class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-3.13.9.tgz"
  sha256 "f75f57714510cdb0b8ee5ba3e69a3c050f7cd1ecc12ce0af9a882ac86ebc15c7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0819d9feeedbf8e5826adc58fc9c068fad82d04050c4328cf2e86a664f97cff0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0819d9feeedbf8e5826adc58fc9c068fad82d04050c4328cf2e86a664f97cff0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0819d9feeedbf8e5826adc58fc9c068fad82d04050c4328cf2e86a664f97cff0"
    sha256 cellar: :any_skip_relocation, sonoma:        "abc38c3b6d528bd067935591acd5e7b6e9790f58e7f48f2d682ba5a66e92dbf3"
    sha256 cellar: :any_skip_relocation, ventura:       "abc38c3b6d528bd067935591acd5e7b6e9790f58e7f48f2d682ba5a66e92dbf3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb280275bd19dd5f5dfed99a8cd307bde44f7c983a44fbfe01d5b78aa77d188d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb280275bd19dd5f5dfed99a8cd307bde44f7c983a44fbfe01d5b78aa77d188d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
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