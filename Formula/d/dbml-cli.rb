class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-3.7.2.tgz"
  sha256 "4e2932f11ec1d7a2fc9232f28228122c09eb1eef6f1a88750505261b4dc5397b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e7ad8e96b1bad2b42712274489925bf11514004176c121c89392c2bb478a4099"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7ad8e96b1bad2b42712274489925bf11514004176c121c89392c2bb478a4099"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7ad8e96b1bad2b42712274489925bf11514004176c121c89392c2bb478a4099"
    sha256 cellar: :any_skip_relocation, sonoma:         "b12be2d0d0c40065b22dd4543e9fe5df044329f5a96c01a143baae421046cb5e"
    sha256 cellar: :any_skip_relocation, ventura:        "b12be2d0d0c40065b22dd4543e9fe5df044329f5a96c01a143baae421046cb5e"
    sha256 cellar: :any_skip_relocation, monterey:       "b12be2d0d0c40065b22dd4543e9fe5df044329f5a96c01a143baae421046cb5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7ad8e96b1bad2b42712274489925bf11514004176c121c89392c2bb478a4099"
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