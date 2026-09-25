class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-10.2.0.tgz"
  sha256 "6333a2c76bed943e77328c72821590876afc9e92b77b515ed9eb963a01014192"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "6cb813737114e956d985491653281c0141492f33c6cf62d4fceffc52a32e1dac"
    sha256 cellar: :any,                 arm64_tahoe:       "6cb813737114e956d985491653281c0141492f33c6cf62d4fceffc52a32e1dac"
    sha256 cellar: :any,                 arm64_sequoia:     "6cb813737114e956d985491653281c0141492f33c6cf62d4fceffc52a32e1dac"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "abc759b84c2ccffdb9c86a040ee1e966795ee6fc3d732be9d740eb92acde3238"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "7180a75ed0afa818fae7fe401aa216700c7be53d306937829c1cd0b1986880ed"
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