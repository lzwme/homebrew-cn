class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-10.3.0.tgz"
  sha256 "419bab0deff4c017ae563607762e8f08d134d88bf145fbb2b657c3da379c303d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "1aeac739ae3ce9546e95a342cfdd68c51ff6b0d5ef8946843f36a67be30d290c"
    sha256 cellar: :any,                 arm64_tahoe:       "1aeac739ae3ce9546e95a342cfdd68c51ff6b0d5ef8946843f36a67be30d290c"
    sha256 cellar: :any,                 arm64_sequoia:     "1aeac739ae3ce9546e95a342cfdd68c51ff6b0d5ef8946843f36a67be30d290c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "be9508fde12272fa403e1d11fb51ab71b6592f0b44daa0f8e3048e0919accf5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "abdc35a3fd8cedff436a7a02813bd1a090ce2752d3bb9a80e955ca9689b76012"
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