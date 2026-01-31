class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-5.5.1.tgz"
  sha256 "3791a83857ca46b40a60af89215c8812ba8582b82453d87855fa7280e3dc3ed1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d5f98e5294dbd9b63c586c9696619193791680d1cc6ee4a39b150dc4844d5255"
    sha256 cellar: :any,                 arm64_sequoia: "666c8bb4c1a2ebab74f022cee1da24ece3cb7279e8c0a63b77d11a34761c7c89"
    sha256 cellar: :any,                 arm64_sonoma:  "666c8bb4c1a2ebab74f022cee1da24ece3cb7279e8c0a63b77d11a34761c7c89"
    sha256 cellar: :any,                 sonoma:        "e3532e1585a01e5cbe7fc024c51e43d50f4bbea597bb580761a903b53133bb2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1642e8dcdcb4aedc36579a0188f8d191864d704bb827c438699bdcd24347f39b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b9738860452878ffdee0e99abaaf0e6272ebae2599bb02449e67f21c2b9aafd"
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