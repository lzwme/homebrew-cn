class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-5.3.0.tgz"
  sha256 "e6053e39a06a99b5e26d45f3372495fce1a02ef18d72245aa24a7875e5df80f1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce74de9c9e471419b19224e6c9566c32aad17db075d12f00818f1d8b93634d6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5901c93bb2652f27613f401ca1aecbc66327e32d8e99ec12f43a1c1ba98689c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5901c93bb2652f27613f401ca1aecbc66327e32d8e99ec12f43a1c1ba98689c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b744abb6f406f7f989f57a476eb12d71d7ef9f7ccf0cbefb99f5e8e0611680a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98121410b3f81ca847e9f6db1beeb9b8a490732ed37a72f5b7f8ed2470e8c7a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b157e85a777de221e6c7c25b49b484350ebb60de9d4134474ec7207e68db9990"
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