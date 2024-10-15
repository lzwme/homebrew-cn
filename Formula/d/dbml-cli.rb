class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-3.9.1.tgz"
  sha256 "a1b500e59cb10a535444d300f31519d788b89faff3807555df31afebadb2563b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8632d7986496a0895eb3c6ff618601c5b33ac38affc08120bab646d9f0a034b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8632d7986496a0895eb3c6ff618601c5b33ac38affc08120bab646d9f0a034b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f8632d7986496a0895eb3c6ff618601c5b33ac38affc08120bab646d9f0a034b"
    sha256 cellar: :any_skip_relocation, sonoma:        "3285fb1b3fc4be5c0dfccb17a099648517f974a8f8ca41bc6d7332d863b35042"
    sha256 cellar: :any_skip_relocation, ventura:       "3285fb1b3fc4be5c0dfccb17a099648517f974a8f8ca41bc6d7332d863b35042"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8632d7986496a0895eb3c6ff618601c5b33ac38affc08120bab646d9f0a034b"
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