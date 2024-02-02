require "language/node"

class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-3.1.3.tgz"
  sha256 "f522961ab2811607a06f5553133971632d3cfb3537666168d27f3a4381ea1ade"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c7db442a6087633627c0d74a5df006c97f3a58540992e195f0c04a0d0ee66cdc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c7db442a6087633627c0d74a5df006c97f3a58540992e195f0c04a0d0ee66cdc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7db442a6087633627c0d74a5df006c97f3a58540992e195f0c04a0d0ee66cdc"
    sha256 cellar: :any_skip_relocation, sonoma:         "ec505a622b2cce8f5d6a4da51cd507619eb5190cddb4168d24d6b2e071811e9d"
    sha256 cellar: :any_skip_relocation, ventura:        "ec505a622b2cce8f5d6a4da51cd507619eb5190cddb4168d24d6b2e071811e9d"
    sha256 cellar: :any_skip_relocation, monterey:       "ec505a622b2cce8f5d6a4da51cd507619eb5190cddb4168d24d6b2e071811e9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d448df37b10dedcc68eb18430229290e51096645308cb3b59e39421a5d9c0c8"
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