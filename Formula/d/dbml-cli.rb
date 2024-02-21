require "language/node"

class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-3.1.7.tgz"
  sha256 "0e44a37705fbc95e2ad09363cb33f7087d7aeca33282938943997ee926ebd9a8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f909b2eae460248e2527c1d569756f3923fe5fb1d608083908ff99718562cab8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f909b2eae460248e2527c1d569756f3923fe5fb1d608083908ff99718562cab8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f909b2eae460248e2527c1d569756f3923fe5fb1d608083908ff99718562cab8"
    sha256 cellar: :any_skip_relocation, sonoma:         "1e76f6b3d24a40c6657461d68c19ddab0a35d0a229e40baa911a6cfaacae664b"
    sha256 cellar: :any_skip_relocation, ventura:        "1e76f6b3d24a40c6657461d68c19ddab0a35d0a229e40baa911a6cfaacae664b"
    sha256 cellar: :any_skip_relocation, monterey:       "1e76f6b3d24a40c6657461d68c19ddab0a35d0a229e40baa911a6cfaacae664b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6022d6fe027c41fdbf55e91fc4264d28d8da2ed7a729aec2306292e17cae9c6e"
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