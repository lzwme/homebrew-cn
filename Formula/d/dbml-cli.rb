class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-10.1.0.tgz"
  sha256 "46bf3da653de4f7bb3541f1808a25aefe96c7152074d1565588541447c7edd45"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5ab7281c970d67a971d929ffb0768ba0742c8e281e899259c6e174c28577b681"
    sha256 cellar: :any,                 arm64_sequoia: "5ab7281c970d67a971d929ffb0768ba0742c8e281e899259c6e174c28577b681"
    sha256 cellar: :any,                 arm64_sonoma:  "5ab7281c970d67a971d929ffb0768ba0742c8e281e899259c6e174c28577b681"
    sha256 cellar: :any,                 sonoma:        "e86eb0f50f1137aec50be82e408db0b0e5e274cd340bd41d070f9007ac06bbc7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1be0f99b1c1c979d73767414d9721ff73172debed8e3f7a5b7523aad43fdd3aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5679f31a3eab63fd26b2db688aa936a0f794e2752b9e58bbb3f506f9e243ce1d"
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