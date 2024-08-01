class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-3.6.2.tgz"
  sha256 "47ed9fd06bd6926126d7c25963bf75f8ef73694bd088418dacc819d4a3a430fc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a91397151628a405c704a03e275cc0b10e7bf0ebca1e1b258c62b8c89a0b2cca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a91397151628a405c704a03e275cc0b10e7bf0ebca1e1b258c62b8c89a0b2cca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a91397151628a405c704a03e275cc0b10e7bf0ebca1e1b258c62b8c89a0b2cca"
    sha256 cellar: :any_skip_relocation, sonoma:         "1a30ba4196f8d0e3619df50872badfb8e1fb0fe0adc5596b8e253ecfb1be1718"
    sha256 cellar: :any_skip_relocation, ventura:        "1a30ba4196f8d0e3619df50872badfb8e1fb0fe0adc5596b8e253ecfb1be1718"
    sha256 cellar: :any_skip_relocation, monterey:       "1a30ba4196f8d0e3619df50872badfb8e1fb0fe0adc5596b8e253ecfb1be1718"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a29fac275b9a00efdd92886c7b6265db044aab0d3b1cb6da0381a5ee32c3dbee"
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