class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-3.9.6.tgz"
  sha256 "c29747649432b597b46a402b66b0bebcad7f347b7045ca6497cafa461a5695fc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9053b0f1b3976d703b7f27529f2bff4e3951e43049ee1ac89a26e360c44b77c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9053b0f1b3976d703b7f27529f2bff4e3951e43049ee1ac89a26e360c44b77c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d9053b0f1b3976d703b7f27529f2bff4e3951e43049ee1ac89a26e360c44b77c"
    sha256 cellar: :any_skip_relocation, sonoma:        "63b63d33667c07793b3514520c93d321a826c2d8e379e99e7fb09fa52b9d4f33"
    sha256 cellar: :any_skip_relocation, ventura:       "63b63d33667c07793b3514520c93d321a826c2d8e379e99e7fb09fa52b9d4f33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5eb0853e4deab5654cdccb368c45d2ed47a85d8bfa54d25515460ed6d171fec"
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