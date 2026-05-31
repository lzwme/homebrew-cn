class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-8.2.3.tgz"
  sha256 "0f2d65c158761559c4012c0584faf602d39e0f083d5da34f8259f9cbb98c2274"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "055de3aaef447160bef25fec89d0f503bf9f42915c4623b5adbfdc1b18efd215"
    sha256 cellar: :any,                 arm64_sequoia: "2c43390c3ad6f57bc96c49b724588d0f3e66f7b93d69b7079b60c06a4685fd48"
    sha256 cellar: :any,                 arm64_sonoma:  "2c43390c3ad6f57bc96c49b724588d0f3e66f7b93d69b7079b60c06a4685fd48"
    sha256 cellar: :any,                 sonoma:        "07c75d682ca9f4bf63de9de1a48e1d70266b7af6697ebeda3b04042fc11ee13c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc744f059118fd5554613307683ca517ac157ef6eeb0fb5a2a87f6fdb6171cd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "783e587ec7995431cf4776f35df477d75631b513dcc66c63713aae47f69d348c"
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