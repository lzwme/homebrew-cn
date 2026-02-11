class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-6.2.0.tgz"
  sha256 "7c746b05bdaec4dfc6e6eb3d6cd987810c2aecf64f9e813def083256d36c8c0f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1aea94228cd35acb3cbb8982bb4a197f9db3e44d244f31b1338f0d4efeea55b8"
    sha256 cellar: :any,                 arm64_sequoia: "36f54e8018ca2cc683722d00546988a6e2bc7c3ca1a6e69b35ae0117774b0393"
    sha256 cellar: :any,                 arm64_sonoma:  "36f54e8018ca2cc683722d00546988a6e2bc7c3ca1a6e69b35ae0117774b0393"
    sha256 cellar: :any,                 sonoma:        "c655581d0c73c00d69bf8d4d9767e70af1e2cd7adeba0cc7e8279728ddf926f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "157f70618f2cdb572955e44901f756ec765b751e672788ffdb11749ade52d00a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f9aa5caa3e45615fa111d10566633b2c394cf73f388a621162a356f1db34b95"
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