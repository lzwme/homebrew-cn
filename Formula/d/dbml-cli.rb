class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-8.2.0.tgz"
  sha256 "e376e59ccbfc3d3a9e873b934789964518423bdc91b896cfd694c69d54cbfbf3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cbd11edc8ae57e19aa9ad592486f7df5cf67bc96bb296bfaa8be1f01b6a56755"
    sha256 cellar: :any,                 arm64_sequoia: "c11ee596029e56a4306a0d21faf895578d4dc9f434545b2ef1a2882562807fcd"
    sha256 cellar: :any,                 arm64_sonoma:  "c11ee596029e56a4306a0d21faf895578d4dc9f434545b2ef1a2882562807fcd"
    sha256 cellar: :any,                 sonoma:        "371b478134803cc1e72bd9eadb9a5566c825253a20e25ce5ce3861e4c05e0623"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8de7ef0fa8637b7ff399f5f6173f2b1a854f96d1b2d6fccd779b2d026c9394b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cabdcb693332ceec5c0ca127fd7b38d0d473dc6511aec8331986902e58e94737"
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