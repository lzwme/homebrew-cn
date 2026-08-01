class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-9.0.0.tgz"
  sha256 "50ba9cf247a09928861558717d1c490589e292f49570d87aa73ba65aa19dc619"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bc47cda7461569ab04b7a29fd8fdead979da6f8e9d53bdb3e419a7d9413d73af"
    sha256 cellar: :any,                 arm64_sequoia: "bc47cda7461569ab04b7a29fd8fdead979da6f8e9d53bdb3e419a7d9413d73af"
    sha256 cellar: :any,                 arm64_sonoma:  "bc47cda7461569ab04b7a29fd8fdead979da6f8e9d53bdb3e419a7d9413d73af"
    sha256 cellar: :any,                 sonoma:        "a7b5012684611de7cb1fb650578e4e321d5c84cf28388578506a7d63d63543e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5aa4c860614f6734f950caa25974488099158c98a1eaab9b3f8c2c5523977859"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acffcb709c36cd78fd35b7423cb8040ecd01325db14c3a281c3f7f613f6d613f"
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