class SchemaEvolutionManager < Formula
  desc "Manage postgresql database schema migrations"
  homepage "https://github.com/mbryzek/schema-evolution-manager"
  url "https://ghfast.top/https://github.com/mbryzek/schema-evolution-manager/archive/refs/tags/0.9.60.tar.gz"
  sha256 "ef011f7cd16bf9b973c13b76492c1dfdc3a695c08eac80de425aa442e0680566"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a901980a4156b98d358315f5984cec33d3d767cd087bde0390b2722e05200ae7"
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