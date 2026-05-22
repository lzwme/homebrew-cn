class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-8.1.0.tgz"
  sha256 "7a01effdbeb25eae8ffc4520c4ddb7037743e5cdfb973a5f917b44620826e99b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "44daf0c9dcc0f72e30aaab0d000c399250bc675c26b60a5c6d08cb998039a89f"
    sha256 cellar: :any,                 arm64_sequoia: "32524c5b8627642e7c9946cb00f418d6996d5f55f59ecbb695e7c9c00f0f0193"
    sha256 cellar: :any,                 arm64_sonoma:  "32524c5b8627642e7c9946cb00f418d6996d5f55f59ecbb695e7c9c00f0f0193"
    sha256 cellar: :any,                 sonoma:        "2064181040569f9fa9136a06fa3dd7e9333f2890ca6868cd4c10854f0b829730"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e183f275635c285f1728a9861ccbd079f3d3852baa38c6b990c799934971a551"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ca612216d5b4f2d3c5e222afe90fe6d91ee6aa67761461db827a33f0ff0a28a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@dbml/cli/node_modules"
    node_modules.glob("oracledb/build/Release/oracledb-*.node").each do |f|
      rm(f) unless f.basename.to_s.match?("#{os}-#{arch}")
    end

    suffix = OS.linux? ? "-gnu" : ""
    node_modules.glob("snowflake-sdk/dist/lib/minicore/binaries/sf_mini_core_*.node").each do |f|
      rm(f) unless f.basename.to_s.match?("#{os}-#{arch}#{suffix}")
    end

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
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