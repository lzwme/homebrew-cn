class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-5.4.0.tgz"
  sha256 "6961cc362cde6d24164dcb14c7ed4fbc89d2a641f7c1c1a918554668d43294e9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9f5b9269df99c2c065034908c27363f6feda054cbecf367156b495af66904219"
    sha256 cellar: :any,                 arm64_sequoia: "73a27d47642bcdb3e7e763f65c372b1163d659bca3706e832323116fd4add65d"
    sha256 cellar: :any,                 arm64_sonoma:  "73a27d47642bcdb3e7e763f65c372b1163d659bca3706e832323116fd4add65d"
    sha256 cellar: :any,                 sonoma:        "b2701b2eef0b9319a2b4216c75673c724cc7379aaebf87b34a29dc4ca2f2bf39"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d421327bc3595aada2dd779ccb41ad4aa989353103c2b018e5df2f56580a4f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c38dac2fc7b25777ae64916f5b782b1ce1bc7eca43b73af655ef0685f605b596"
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