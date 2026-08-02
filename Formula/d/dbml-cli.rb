class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-9.1.1.tgz"
  sha256 "3b582835ed6255c3f013e2ccb746e68d5e41a709a7824fb6ee487f99bcebb3d7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a2b687c3475dff7e86cab8c9c5b0ab70b3b9c130b35e90e0d4b579d83a4b46f2"
    sha256 cellar: :any,                 arm64_sequoia: "a2b687c3475dff7e86cab8c9c5b0ab70b3b9c130b35e90e0d4b579d83a4b46f2"
    sha256 cellar: :any,                 arm64_sonoma:  "a2b687c3475dff7e86cab8c9c5b0ab70b3b9c130b35e90e0d4b579d83a4b46f2"
    sha256 cellar: :any,                 sonoma:        "f6db971b2c258f85e23d98529eca53d590ad87b437043622205c0596b4a1fb6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95824d8078aa10f270d1ce00859dc618ea2a72cffc9f92b5c3a3aa214032c25d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6be3be02c3e6b8be0ef5f871b3b2a87b1c9a686bb36f7053b377f8bdf9fa3aa3"
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