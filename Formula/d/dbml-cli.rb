class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-3.11.0.tgz"
  sha256 "52f00a0e2f64d4c68222ec44be6e161884a4b0e1af86e3191738211ccc3309b8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26ccf2099e3d37f20f27268decb957197688a6fc6c75264adeac3c8abf74a5ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26ccf2099e3d37f20f27268decb957197688a6fc6c75264adeac3c8abf74a5ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "26ccf2099e3d37f20f27268decb957197688a6fc6c75264adeac3c8abf74a5ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "32bff44268af22ac1c97611166f2690748d8b5cd226add57dd4548382aae4168"
    sha256 cellar: :any_skip_relocation, ventura:       "32bff44268af22ac1c97611166f2690748d8b5cd226add57dd4548382aae4168"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26ccf2099e3d37f20f27268decb957197688a6fc6c75264adeac3c8abf74a5ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26ccf2099e3d37f20f27268decb957197688a6fc6c75264adeac3c8abf74a5ab"
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