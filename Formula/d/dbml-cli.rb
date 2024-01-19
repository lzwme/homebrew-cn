require "language/node"

class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-3.1.1.tgz"
  sha256 "8e73a052114fe94c8553a13acaee6fbe78d8aef40977ee329b1bc4265fbb89b4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "307d7308be90d1d2e92c93f4db46be195d48625af9303d89b940c0fa8fc80b09"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "307d7308be90d1d2e92c93f4db46be195d48625af9303d89b940c0fa8fc80b09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "307d7308be90d1d2e92c93f4db46be195d48625af9303d89b940c0fa8fc80b09"
    sha256 cellar: :any_skip_relocation, sonoma:         "23116036613321538869bbb6f4c31d640c2a1cbfc72d6a743a5ef98709408a19"
    sha256 cellar: :any_skip_relocation, ventura:        "23116036613321538869bbb6f4c31d640c2a1cbfc72d6a743a5ef98709408a19"
    sha256 cellar: :any_skip_relocation, monterey:       "23116036613321538869bbb6f4c31d640c2a1cbfc72d6a743a5ef98709408a19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0edb7c6d68c59193c2a6aa864de72f9d5dd68bcc668f6452cc00fc68eebcc3e"
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