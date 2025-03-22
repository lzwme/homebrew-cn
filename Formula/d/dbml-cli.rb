class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-3.10.2.tgz"
  sha256 "4f45ac746281ed6849c2dc9c8fac65f45e404ba15060cec85e6513ac9f1f892f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0655f60ab37c73977f5595d52da23bbde35a3eb738bb2092f3dbc8a3dfbfa098"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0655f60ab37c73977f5595d52da23bbde35a3eb738bb2092f3dbc8a3dfbfa098"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0655f60ab37c73977f5595d52da23bbde35a3eb738bb2092f3dbc8a3dfbfa098"
    sha256 cellar: :any_skip_relocation, sonoma:        "118b6b37430890713e4c2d51671e44a5f5cf39769a5654418a199b0c5ad2f8a1"
    sha256 cellar: :any_skip_relocation, ventura:       "118b6b37430890713e4c2d51671e44a5f5cf39769a5654418a199b0c5ad2f8a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf97a0b7aa54e7d35d0a8530020a413f9ed36e10732bf2c0bf8d85d6090a1e99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0655f60ab37c73977f5595d52da23bbde35a3eb738bb2092f3dbc8a3dfbfa098"
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