require "language/node"

class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-3.6.0.tgz"
  sha256 "c1741b3507a7db10b6176e09c92d50d4fd59d2d13b28e72c773ee4ec5b6e9d07"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5ea1a40c5cfa0409c40e475e33324fa21507213750d2edda27b7cc4be3edbbce"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ea1a40c5cfa0409c40e475e33324fa21507213750d2edda27b7cc4be3edbbce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ea1a40c5cfa0409c40e475e33324fa21507213750d2edda27b7cc4be3edbbce"
    sha256 cellar: :any_skip_relocation, sonoma:         "03ae570d640f86525db2e7c816c646a8ecaca165d04f27b8d02c0d7274c13a8e"
    sha256 cellar: :any_skip_relocation, ventura:        "03ae570d640f86525db2e7c816c646a8ecaca165d04f27b8d02c0d7274c13a8e"
    sha256 cellar: :any_skip_relocation, monterey:       "03ae570d640f86525db2e7c816c646a8ecaca165d04f27b8d02c0d7274c13a8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e78b72a1b806474fd8035f1484da2d8efb847409ede12e1d8a872bffd1cd74da"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
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