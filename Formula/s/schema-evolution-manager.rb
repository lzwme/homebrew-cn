class SchemaEvolutionManager < Formula
  desc "Manage postgresql database schema migrations"
  homepage "https://github.com/mbryzek/schema-evolution-manager"
  url "https://ghfast.top/https://github.com/mbryzek/schema-evolution-manager/archive/refs/tags/0.9.62.tar.gz"
  sha256 "b9dd1c8eb3bd78f467b61da42bc3c4e0495fd6bfb7664d9d041f3f0cf525a23c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ac0280f20cee6d70f37a5d7d32658fc06c78d238eb03cdbbccbcfe20ee40e74c"
  end

  uses_from_macos "ruby"

  def install
    system "./install.sh", prefix
  end

  test do
    (testpath/"new.sql").write <<~SQL
      CREATE TABLE IF NOT EXISTS test (id text);
    SQL
    system "git", "init", "."
    assert_match "File staged in git", shell_output("#{bin}/sem-add ./new.sql")
  end
end