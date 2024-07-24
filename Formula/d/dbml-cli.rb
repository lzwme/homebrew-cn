require "language/node"

class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-3.6.1.tgz"
  sha256 "d6eef86bd841dac598b7641d725f1932ef3dc0f87e6047bdf552defca9262f48"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "28894b9a1ded4709811120125320219ba25988411f33c08d44e1db2387599489"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "28894b9a1ded4709811120125320219ba25988411f33c08d44e1db2387599489"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28894b9a1ded4709811120125320219ba25988411f33c08d44e1db2387599489"
    sha256 cellar: :any_skip_relocation, sonoma:         "83c8cba1988393d248c3fd6e118b5224044a1ce71752481f1b5848ec8c07634b"
    sha256 cellar: :any_skip_relocation, ventura:        "83c8cba1988393d248c3fd6e118b5224044a1ce71752481f1b5848ec8c07634b"
    sha256 cellar: :any_skip_relocation, monterey:       "5da7c085730f8fa4c963cd97f7426e19f19daa997be51b1b912e3c2b18f23219"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2ccc0207cf763f8c945d5a9d1df48ab96fb680fcd97e6728df237029d93a6be"
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