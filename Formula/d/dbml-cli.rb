class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-5.3.1.tgz"
  sha256 "09da9a76ac734d24101e403ccc5e856a7764806f38b01e2eaf611eb90bcf59ae"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "feabf46be2f6e07a88ec032fcd9d4a7a14753ff951316d3c4ca28883278ca4f2"
    sha256 cellar: :any,                 arm64_sequoia: "77eacb6cdb311f404f7d58f03c5152aef650003ad585f8673184ad84532eaf3a"
    sha256 cellar: :any,                 arm64_sonoma:  "77eacb6cdb311f404f7d58f03c5152aef650003ad585f8673184ad84532eaf3a"
    sha256 cellar: :any,                 sonoma:        "6c65ae3c4dc07032f50ef08a605a07406c74b1a23bf4b19ed0a41b983f7f6a9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a01e6cd7336d19ea08e630c6e878b51e5a17740291093dc08cc6202d62db1b52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0cc6caf027c642adb47b040fc04229a05a2af6897a3c7ab38a90db1a47d2064"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

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