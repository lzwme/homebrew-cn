class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-3.8.1.tgz"
  sha256 "a82667fcb0055ae4786480d9aefe44433431a8d8506b93ed3004e3dc284e7f04"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8247d9e5abdd546e13b5d1d4e6790372e93233397a8717d24b113087bfe52137"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d5e389d7fec4ebd41ec9f00aa31ee27a22d885d75cc8988daee5b35e8db732e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5e389d7fec4ebd41ec9f00aa31ee27a22d885d75cc8988daee5b35e8db732e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5e389d7fec4ebd41ec9f00aa31ee27a22d885d75cc8988daee5b35e8db732e9"
    sha256 cellar: :any_skip_relocation, sonoma:         "ea2f0ca1e9fc0b49e4868e5d9e048abe88f6018e622123620c8ddc36565e3a4b"
    sha256 cellar: :any_skip_relocation, ventura:        "ea2f0ca1e9fc0b49e4868e5d9e048abe88f6018e622123620c8ddc36565e3a4b"
    sha256 cellar: :any_skip_relocation, monterey:       "ea2f0ca1e9fc0b49e4868e5d9e048abe88f6018e622123620c8ddc36565e3a4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7506f1b467e430af85bd15e507add049f4f2738de7b78c320f99132cb205f427"
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