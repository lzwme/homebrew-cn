class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-6.1.0.tgz"
  sha256 "aa673d06a60c3c7984abf85c0091e6ea60326a43724c8eb32c3b03b9704f47e7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "542f8384eee3994b4a924d8722516f43d84edc74862ba4d37a0cce2c12bbebe2"
    sha256 cellar: :any,                 arm64_sequoia: "b64ea1cdea17e0d0a98d09236682e220c470ceaac1d79882644ebd758b7e3010"
    sha256 cellar: :any,                 arm64_sonoma:  "b64ea1cdea17e0d0a98d09236682e220c470ceaac1d79882644ebd758b7e3010"
    sha256 cellar: :any,                 sonoma:        "2bcb5d959aaf879bc127b63426044ace74b4da2e17a4611d4b43984680413236"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee1ad3a1c07c9f339c9440de8a4766d030399245e7075ce19a6b33b611354084"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "787fdd994259cf9a0e10edc52d9e6f60cc15609b051b1fa35ebfb874128f2e90"
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