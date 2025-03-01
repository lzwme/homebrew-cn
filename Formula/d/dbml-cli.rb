class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-3.10.1.tgz"
  sha256 "9f7a07bc4b6d79bc8538cf61837563332c2553d93001dadef40eca6155b6511d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3bf7fa5231df6beadd8de4edd7d7027aeb8c034e8f11651a275790ae503cf2ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3bf7fa5231df6beadd8de4edd7d7027aeb8c034e8f11651a275790ae503cf2ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3bf7fa5231df6beadd8de4edd7d7027aeb8c034e8f11651a275790ae503cf2ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "71f4ce9e22b52da5087c663db90a8956cbf47209b268251c216ee235ab1393dd"
    sha256 cellar: :any_skip_relocation, ventura:       "71f4ce9e22b52da5087c663db90a8956cbf47209b268251c216ee235ab1393dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3bf7fa5231df6beadd8de4edd7d7027aeb8c034e8f11651a275790ae503cf2ad"
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