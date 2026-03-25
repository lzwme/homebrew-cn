class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-6.5.0.tgz"
  sha256 "1d718a7290322fd263aab528391e365de0c6c6ce97a3938a80711246b4ad4dce"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5fd7f874ca2cdfa6422dfceb0ef78d1aa3f55fd7bb9174e7e50215d7a0886974"
    sha256 cellar: :any,                 arm64_sequoia: "f6ad26c45c58dc0e106c5a30de2841bf10859dc847468a0dd7988df84e7db1e5"
    sha256 cellar: :any,                 arm64_sonoma:  "f6ad26c45c58dc0e106c5a30de2841bf10859dc847468a0dd7988df84e7db1e5"
    sha256 cellar: :any,                 sonoma:        "bfd124cef587cc0746b29610200cbfb72d1f66aa4866620ad5dfe2e804187902"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e06d896133634fc0169e8361418c80a98845372884d0af7b6ed4eaf5a8e9582"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "767bcbf814d7cfd35578f67c078c935b184d58992690e8e0deed4d16ada3f5f9"
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