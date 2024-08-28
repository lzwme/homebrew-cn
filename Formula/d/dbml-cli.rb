class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-3.8.0.tgz"
  sha256 "e9da38c02fabf76bfae8a71666d7be4d7dbd2b8c4f7b6dc50b77e0182bb06bc8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "df608dd6b8817b12a942ef724ae0ede01086c644b54a1aec7aa0f91d8d12ffe0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df608dd6b8817b12a942ef724ae0ede01086c644b54a1aec7aa0f91d8d12ffe0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df608dd6b8817b12a942ef724ae0ede01086c644b54a1aec7aa0f91d8d12ffe0"
    sha256 cellar: :any_skip_relocation, sonoma:         "d2bae3f0b9448310439569bbaf0a577fa1f68dd94c2151533281fa9ca219dffe"
    sha256 cellar: :any_skip_relocation, ventura:        "d2bae3f0b9448310439569bbaf0a577fa1f68dd94c2151533281fa9ca219dffe"
    sha256 cellar: :any_skip_relocation, monterey:       "d2bae3f0b9448310439569bbaf0a577fa1f68dd94c2151533281fa9ca219dffe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df608dd6b8817b12a942ef724ae0ede01086c644b54a1aec7aa0f91d8d12ffe0"
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