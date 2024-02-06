require "language/node"

class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-3.1.4.tgz"
  sha256 "f92197fdb9bf212d9402c42ae119d04c467d214479da9023fa3d042141b763bc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3c86aee29a91487d35b1f8b44c409ee1a2e629df6b488abe50b5969b2614674e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c86aee29a91487d35b1f8b44c409ee1a2e629df6b488abe50b5969b2614674e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c86aee29a91487d35b1f8b44c409ee1a2e629df6b488abe50b5969b2614674e"
    sha256 cellar: :any_skip_relocation, sonoma:         "19a3125955c1c7e230ea308d007979979f900a7f11f0bc1e5e55708436eded28"
    sha256 cellar: :any_skip_relocation, ventura:        "19a3125955c1c7e230ea308d007979979f900a7f11f0bc1e5e55708436eded28"
    sha256 cellar: :any_skip_relocation, monterey:       "19a3125955c1c7e230ea308d007979979f900a7f11f0bc1e5e55708436eded28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2901aca51bf327c635cb500760ef505c99d66027f5655dc5a5c809eda4dc515c"
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