class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-8.0.0.tgz"
  sha256 "dae26858ed891b11d5f775d3bfb4f3c82f240e85fa8ec95cddd487db31a102c9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ed8ad3c1ff3a4a80f7147de24f2a44c273bd6f3299880ffa49fd2a8a10243f1a"
    sha256 cellar: :any,                 arm64_sequoia: "2ead5d1e0387543866d60d6b5a4d17c75b014546e447a925fc0ac378053a0193"
    sha256 cellar: :any,                 arm64_sonoma:  "2ead5d1e0387543866d60d6b5a4d17c75b014546e447a925fc0ac378053a0193"
    sha256 cellar: :any,                 sonoma:        "08b10e2469eebf417fb5118b6995ed9284da0dc8c28963e51e52800691934cf1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d55d482e8c29d71f09648230d7e478a185edfb1d9abfe7826344013d652a6700"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04818efcd71b863addef491c8939312d67710e788ead97e4e83ad7e73f386354"
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