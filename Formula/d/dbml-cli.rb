require "language/node"

class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-3.1.2.tgz"
  sha256 "6b9de05457da1071f8c8d155badd31e3b691edb82e202122a5760606009c2add"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cc5287fcbe17b0da2d649a033d62ebe2ef8b21dec5bd38ad43efb1bc816357be"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc5287fcbe17b0da2d649a033d62ebe2ef8b21dec5bd38ad43efb1bc816357be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc5287fcbe17b0da2d649a033d62ebe2ef8b21dec5bd38ad43efb1bc816357be"
    sha256 cellar: :any_skip_relocation, sonoma:         "66be2f8ec9aa85eada58d8a961d159ee411bc60daaa5939ba69770fa24a65b9b"
    sha256 cellar: :any_skip_relocation, ventura:        "66be2f8ec9aa85eada58d8a961d159ee411bc60daaa5939ba69770fa24a65b9b"
    sha256 cellar: :any_skip_relocation, monterey:       "66be2f8ec9aa85eada58d8a961d159ee411bc60daaa5939ba69770fa24a65b9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1cf993e5e1002339ad62f0c9b4cbda715adc9a2222452ddca0cb20f73cb65adc"
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