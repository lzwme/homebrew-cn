class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-8.2.2.tgz"
  sha256 "6ecaf25d0d5d12bfc9923d3d30ef4862178333847edcdd7ccc916476d692e954"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9eb4e1b48e4edc274520c7e041687c145a9eda9d312c65d0dd4ebf0d4edca423"
    sha256 cellar: :any,                 arm64_sequoia: "deed08396334daf64c4a69e495db07897dd5003ee0726e06422d80cf20735ce1"
    sha256 cellar: :any,                 arm64_sonoma:  "deed08396334daf64c4a69e495db07897dd5003ee0726e06422d80cf20735ce1"
    sha256 cellar: :any,                 sonoma:        "94e9173422f343dd31f081704f4112b79aca315965e692468da6b9252905e418"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "048a91119bce150d312c0cef1099cbe5aefe28b8263433b9f1e31e8065976fe6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2b9a3b27f9aac776d050f916b807266d1d752fa1b08612430b86e69a2232e77"
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