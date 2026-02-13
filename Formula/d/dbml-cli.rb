class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-6.2.1.tgz"
  sha256 "163704efdebec592cd1e0c362aea52b29e7eb0793f3d5777912d3e324f11761a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e05c005cf96be18afe28c02ceb931806e30ce2283011adeb4fed78365fa2bd0a"
    sha256 cellar: :any,                 arm64_sequoia: "afe9c1773ad97fa809e275e3a76082f7b8d792569f7f098c6f8c6413b9363679"
    sha256 cellar: :any,                 arm64_sonoma:  "afe9c1773ad97fa809e275e3a76082f7b8d792569f7f098c6f8c6413b9363679"
    sha256 cellar: :any,                 sonoma:        "bcda470c7c398930a5d54e170ded1c52200b75fb1b45c99e84f2354531fbd73a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d174dce4e1f0b2560f989578fbaccade3b3159c2279cc3de12ee134621945e5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1bfdca07dbd66c6f14b707b20f46a3a4f98c4b1e6a1c7dbb1b7191bd750a6d21"
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