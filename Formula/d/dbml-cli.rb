class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-3.7.4.tgz"
  sha256 "5d1ea849bd5f45c25c48c55308eccd0182648f9313a811282ce01cc2dc7d39b2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aa7b965cdbccd3ee05b7812561525c9f19fa6b63a2ca752f3ad0e63d4f1bce76"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa7b965cdbccd3ee05b7812561525c9f19fa6b63a2ca752f3ad0e63d4f1bce76"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa7b965cdbccd3ee05b7812561525c9f19fa6b63a2ca752f3ad0e63d4f1bce76"
    sha256 cellar: :any_skip_relocation, sonoma:         "b45cf266274b240d427cd63c29f44906c638ff92b5ab54989b78498f5e1f2bec"
    sha256 cellar: :any_skip_relocation, ventura:        "b45cf266274b240d427cd63c29f44906c638ff92b5ab54989b78498f5e1f2bec"
    sha256 cellar: :any_skip_relocation, monterey:       "b45cf266274b240d427cd63c29f44906c638ff92b5ab54989b78498f5e1f2bec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa7b965cdbccd3ee05b7812561525c9f19fa6b63a2ca752f3ad0e63d4f1bce76"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    sql_file = testpath/"test.sql"
    sql_file.write <<~EOS
      CREATE TABLE "staff" (
        "id" INT PRIMARY KEY,
        "name" VARCHAR,
        "age" INT,
        "email" VARCHAR
      );
    EOS

    expected_dbml = <<~EOS
      Table "staff" {
        "id" INT [pk]
        "name" VARCHAR
        "age" INT
        "email" VARCHAR
      }
    EOS

    assert_match version.to_s, shell_output("#{bin}/dbml2sql --version")
    assert_equal expected_dbml, shell_output("#{bin}/sql2dbml #{sql_file}").chomp
  end
end