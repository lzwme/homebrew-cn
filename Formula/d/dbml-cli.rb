class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-3.13.2.tgz"
  sha256 "1b145cdae37de29889b29652fb03ee17e37d5d4f54edbd76f340d9d3b4b642f9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5e2f722159e5bb2f356e1f6ca9c8217d7a3696eace5c4a2db14e0c1dc51c795"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5e2f722159e5bb2f356e1f6ca9c8217d7a3696eace5c4a2db14e0c1dc51c795"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b5e2f722159e5bb2f356e1f6ca9c8217d7a3696eace5c4a2db14e0c1dc51c795"
    sha256 cellar: :any_skip_relocation, sonoma:        "237cf53dc5b68674f87055134bd9a2757e41cb25e362e9eed131f697102804f5"
    sha256 cellar: :any_skip_relocation, ventura:       "237cf53dc5b68674f87055134bd9a2757e41cb25e362e9eed131f697102804f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5e2f722159e5bb2f356e1f6ca9c8217d7a3696eace5c4a2db14e0c1dc51c795"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5e2f722159e5bb2f356e1f6ca9c8217d7a3696eace5c4a2db14e0c1dc51c795"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    sql_file = testpath/"test.sql"
    sql_file.write <<~SQL
      CREATE TABLE "staff" (
        "id" INT PRIMARY KEY,
        "name" VARCHAR,
        "age" INT,
        "email" VARCHAR
      );
    SQL

    expected_dbml = <<~SQL
      Table "staff" {
        "id" INT [pk]
        "name" VARCHAR
        "age" INT
        "email" VARCHAR
      }
    SQL

    assert_match version.to_s, shell_output("#{bin}/dbml2sql --version")
    assert_equal expected_dbml, shell_output("#{bin}/sql2dbml #{sql_file}").chomp
  end
end