require "language/node"

class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-3.4.2.tgz"
  sha256 "91b5305024dd95b40db976dee8d3749fdf426daa55c530da0e3d4045925bd351"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2750782ca56a0dc967291e7da8997c3df7f512159fc85c041be099669d7cc75f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2750782ca56a0dc967291e7da8997c3df7f512159fc85c041be099669d7cc75f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2750782ca56a0dc967291e7da8997c3df7f512159fc85c041be099669d7cc75f"
    sha256 cellar: :any_skip_relocation, sonoma:         "ef0c7380982144d56946ad2a1ae0a360fd202251cffc78c2aa5f689949f41d2b"
    sha256 cellar: :any_skip_relocation, ventura:        "ef0c7380982144d56946ad2a1ae0a360fd202251cffc78c2aa5f689949f41d2b"
    sha256 cellar: :any_skip_relocation, monterey:       "ef0c7380982144d56946ad2a1ae0a360fd202251cffc78c2aa5f689949f41d2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd1c4a5b271ba64a8f46ffc485777dec9b40a8d85b4c9212523a7c70106c4a00"
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