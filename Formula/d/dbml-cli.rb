class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-8.2.1.tgz"
  sha256 "4427b1b3751a17691d32815eb810c166787e294c21b8d3b5dcefc6f8f430d424"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a4e240d3b0a5f4e00c0fae40ccff5a9b284b9456909069bb352841222e8ab683"
    sha256 cellar: :any,                 arm64_sequoia: "0b5017fc61ca962574a6d6e060c9d5c65da5a792767562009e3665af5a7303c1"
    sha256 cellar: :any,                 arm64_sonoma:  "0b5017fc61ca962574a6d6e060c9d5c65da5a792767562009e3665af5a7303c1"
    sha256 cellar: :any,                 sonoma:        "3a3e4afd65402bac44e78e45f5e839a369682d09fbf39c01397e8be80dd2f0ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90fd04162248e706fcaf1a1e45c1684e0e2ee5323c52421b7d70a7d1c40317e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1550536b319f501229eedf914c1c1867177a983a9fec3788e411a4221c864af7"
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