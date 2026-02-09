class Graphqlite < Formula
  desc "SQLite graph database extension"
  homepage "https://colliery-io.github.io/graphqlite/"
  url "https://ghfast.top/https://github.com/colliery-io/graphqlite/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "dca119e108b7377bb6fe84fa22ca329edf6966e89336aab8760057c620c57a5c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "488f5354f8b0dbd2aa1ac019064dd2c2b12a0518bf395ecfe6de1a9bac89f9f4"
    sha256 cellar: :any,                 arm64_sequoia: "50b4de1f427594d5d9ece3a0eb56b068db1d83b8aaf98d9e20f508bcf5029f7f"
    sha256 cellar: :any,                 arm64_sonoma:  "6bb774864f4cf822853069deb7095c144487c683b85f125b9c93564aa937133d"
    sha256 cellar: :any,                 sonoma:        "4f8eaa5ee0e996868fd5bb8f84cd867a2009171191c14b884357b821b1be724d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9f3da8bc16e750af8f08feb19b78f57b906dd64af19b847e7a573e2818167cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcf96aa17f51892e2e413ef5349398a61b49148d56070b102e3a97f1d11874b1"
  end

  depends_on "bison" => :build # macOS bison is too old
  depends_on "sqlite"          # macOS sqlite can't load extensions

  uses_from_macos "flex" => :build

  def install
    system "make", "extension", "RELEASE=1"
    lib_ext = OS.mac? ? "dylib" : "so"
    (lib/"sqlite").install "build/graphqlite.#{lib_ext}"
  end

  def caveats
    <<~EOS
      The SQLite extension is installed in #{opt_lib}/sqlite.
      To load it in the SQLite CLI:
        .load #{opt_lib}/sqlite/graphqlite
    EOS
  end

  test do
    sql = <<~SQL
      .load #{opt_lib}/sqlite/graphqlite
      -- Create people
      SELECT cypher('CREATE (a:Person {name: "Alice", age: 30})');
      SELECT cypher('CREATE (b:Person {name: "Bob", age: 25})');
      SELECT cypher('CREATE (c:Person {name: "Charlie", age: 35})');

      -- Create relationships
      SELECT cypher('
          MATCH (a:Person {name: "Alice"}), (b:Person {name: "Bob"})
          CREATE (a)-[:KNOWS]->(b)
      ');
      SELECT cypher('
          MATCH (b:Person {name: "Bob"}), (c:Person {name: "Charlie"})
          CREATE (b)-[:KNOWS]->(c)
      ');

      -- Query friends of friends
      SELECT cypher('
          MATCH (a:Person {name: "Alice"})-[:KNOWS]->()-[:KNOWS]->(fof)
          RETURN fof.name
      ');
    SQL
    assert_match '{"fof.name": "Charlie"}', pipe_output("#{Formula["sqlite"].opt_bin}/sqlite3", sql)
  end
end