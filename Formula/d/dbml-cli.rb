class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-8.2.4.tgz"
  sha256 "5164d4f38a10d4c65d603722ae1c347b16bbf85f92d3c1eaa84c3b28316a9420"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4cb03f7fd444abfcd9fc9ceb5eb2357be166402514eaee7101d3fdc3e9cde93b"
    sha256 cellar: :any,                 arm64_sequoia: "060ec8db3c6398e513c2540a23f81a3b12f35a87113654358fd8cdbf4da03126"
    sha256 cellar: :any,                 arm64_sonoma:  "060ec8db3c6398e513c2540a23f81a3b12f35a87113654358fd8cdbf4da03126"
    sha256 cellar: :any,                 sonoma:        "679e8d701fb97aeb45f68ff17527b1d1e856c39a133d48087f0027900cba78a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d40d522760f87b33477508737f6e8afff49e798ec6f110e5ff6e0702e487d51f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54bb25e6fc11eb51e8a8c1de9a6d85d86b7c59160d9f188068e82cbf047183a0"
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