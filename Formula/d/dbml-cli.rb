class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-6.0.0.tgz"
  sha256 "7784414b035a84b7ad553a7dfb363852e040733054aef1b6a88b0d857872a1a7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "840f8063efe8a9f4cc0d41e6260b9f5f8786f995bd7a050d04621a43a53e2a2f"
    sha256 cellar: :any,                 arm64_sequoia: "bcfcce910213f100b7e50a27367a72cc6440e11dd32b2c9c3ea64339103a37fc"
    sha256 cellar: :any,                 arm64_sonoma:  "bcfcce910213f100b7e50a27367a72cc6440e11dd32b2c9c3ea64339103a37fc"
    sha256 cellar: :any,                 sonoma:        "4138d9bfe9df5801c3570f625d3a01137758f67d901bae1ec7fb24fd1c705a19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c69cb18763457c6a0c7d5df17a9e27a485b424060383b8f1a458c6c37a785f85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5533fdff26ff74755fa88af5e8e24a6e881927a4ca6916cb13092d176df8f87f"
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