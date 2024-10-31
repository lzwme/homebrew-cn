class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-3.9.3.tgz"
  sha256 "535a63e2525d030c28cca49b1e55ea7265816af2586121a4ef34096fb66555c6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "321f3a0da02b9c0bd9def0fd7f89239aedabd80d5e182dd7bd71b988df737735"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "321f3a0da02b9c0bd9def0fd7f89239aedabd80d5e182dd7bd71b988df737735"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "321f3a0da02b9c0bd9def0fd7f89239aedabd80d5e182dd7bd71b988df737735"
    sha256 cellar: :any_skip_relocation, sonoma:        "412387468529963a8d1e82e5b48d96096de5ebb63271f9a5f8ec7ff3eb833ac3"
    sha256 cellar: :any_skip_relocation, ventura:       "412387468529963a8d1e82e5b48d96096de5ebb63271f9a5f8ec7ff3eb833ac3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "321f3a0da02b9c0bd9def0fd7f89239aedabd80d5e182dd7bd71b988df737735"
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