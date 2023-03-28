require "language/node"

class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-2.5.2.tgz"
  sha256 "3cd6829f04b5716a2570949ed4e36ae86901078085e9bed31305812651873663"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d7ab3e40a879f58af3c86bb9df8c95b36292ffaf23de5fd2515c3c9b0d379a2d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7ab3e40a879f58af3c86bb9df8c95b36292ffaf23de5fd2515c3c9b0d379a2d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d7ab3e40a879f58af3c86bb9df8c95b36292ffaf23de5fd2515c3c9b0d379a2d"
    sha256 cellar: :any_skip_relocation, ventura:        "f95d20cae4045620b6c0126a3bb5de6e7cfc7a9655241ed0afc4f8d69117b157"
    sha256 cellar: :any_skip_relocation, monterey:       "f95d20cae4045620b6c0126a3bb5de6e7cfc7a9655241ed0afc4f8d69117b157"
    sha256 cellar: :any_skip_relocation, big_sur:        "f95d20cae4045620b6c0126a3bb5de6e7cfc7a9655241ed0afc4f8d69117b157"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4161b5e7da0288272f4638273f91a9f5aefb31fa2683587dfdf1508465bf1aac"
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