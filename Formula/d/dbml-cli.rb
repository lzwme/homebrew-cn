class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-3.13.1.tgz"
  sha256 "9bae46251bd5ac8dc52983d7ff62a171fe81d65b1da039d0041a410c0f86d184"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dfc994255fae5db9f19d11cd528e7bd3ea27b80dba4fb36fe88d6521575cfc8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dfc994255fae5db9f19d11cd528e7bd3ea27b80dba4fb36fe88d6521575cfc8a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dfc994255fae5db9f19d11cd528e7bd3ea27b80dba4fb36fe88d6521575cfc8a"
    sha256 cellar: :any_skip_relocation, sonoma:        "324c9d303c3a9d1881eb409116d62e6888efdf94f8be3e57c1c4948171d78a90"
    sha256 cellar: :any_skip_relocation, ventura:       "324c9d303c3a9d1881eb409116d62e6888efdf94f8be3e57c1c4948171d78a90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dfc994255fae5db9f19d11cd528e7bd3ea27b80dba4fb36fe88d6521575cfc8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfc994255fae5db9f19d11cd528e7bd3ea27b80dba4fb36fe88d6521575cfc8a"
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