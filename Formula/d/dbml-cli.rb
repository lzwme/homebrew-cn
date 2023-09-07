require "language/node"

class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-2.6.0.tgz"
  sha256 "ffdfc5fd8fd9723c07fcde232994a9a54760e0f2634a3afc748303ae4ec951cf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e274651e5d49958388e18aea38f74201ed25bc19448807bf34e784d2aa61b52f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e274651e5d49958388e18aea38f74201ed25bc19448807bf34e784d2aa61b52f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e274651e5d49958388e18aea38f74201ed25bc19448807bf34e784d2aa61b52f"
    sha256 cellar: :any_skip_relocation, ventura:        "fdccf17f37f18d22d95697b39c452234ac321d5f4943303c424f3058bdd23108"
    sha256 cellar: :any_skip_relocation, monterey:       "fdccf17f37f18d22d95697b39c452234ac321d5f4943303c424f3058bdd23108"
    sha256 cellar: :any_skip_relocation, big_sur:        "fdccf17f37f18d22d95697b39c452234ac321d5f4943303c424f3058bdd23108"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11b59414d0609e03ef6d8fefdc6ec228bb21323ddfd45477814c891d9021463b"
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