class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-10.0.0.tgz"
  sha256 "0f95b73ad580f48098a2aadd6222433fa73904661ee84b7487f198349678fb05"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1b6a3070c63ef44d3329af479a9c3f470b259503313833bdf086d8e187d529cf"
    sha256 cellar: :any,                 arm64_sequoia: "1b6a3070c63ef44d3329af479a9c3f470b259503313833bdf086d8e187d529cf"
    sha256 cellar: :any,                 arm64_sonoma:  "1b6a3070c63ef44d3329af479a9c3f470b259503313833bdf086d8e187d529cf"
    sha256 cellar: :any,                 sonoma:        "92036707d4604edb2a34d352d26784733e1b52422c1e7632dc8db79181084106"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49d665b425828cbea74ce5e9813771f7690587553fcf8cbf05545387f30e4eb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "295947ddb0822a72892c2e4d8761baccb08c7036e95e25a43ba3b93becc96633"
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