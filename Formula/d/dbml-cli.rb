class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-7.1.0.tgz"
  sha256 "d57899254622b6d03550623984c3161a77f9896b507fdaff9e3b16b670cd8dfb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b2a7e70c52b7a5d5b4f884c14db70d2b613e757670c111ad4a3f51cf31021272"
    sha256 cellar: :any,                 arm64_sequoia: "6bc80a97e9fa519f25a7c40b1da6007ce45f2a8cdbe1d33d03719753263b7a7b"
    sha256 cellar: :any,                 arm64_sonoma:  "6bc80a97e9fa519f25a7c40b1da6007ce45f2a8cdbe1d33d03719753263b7a7b"
    sha256 cellar: :any,                 sonoma:        "4c2563c98c107494c814444ab0274ed4e5a3890691f17e137805aef7dffd375c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9666fad427bdba083b052d86824e995a9b877ff56ed51abf17a789a2ce3ba0ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6664c575982e4e98e029f695d9d87ae4cb42305a3471663e6e5b68ca31e197c2"
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