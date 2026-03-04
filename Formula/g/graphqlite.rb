class Graphqlite < Formula
  desc "SQLite graph database extension"
  homepage "https://colliery-io.github.io/graphqlite/"
  url "https://ghfast.top/https://github.com/colliery-io/graphqlite/archive/refs/tags/v0.3.7.tar.gz"
  sha256 "1748076784a186c0463280ecee43226f73b2f8dc8b220bfb0809c89233008682"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8b2b78218a659a2b0db423af482ea92d88ab63800520cc6f96905c4b7df7e743"
    sha256 cellar: :any,                 arm64_sequoia: "97a03e295221ba300e95c3f80ac216548f0d560f739185b54108ae6d4f89cfff"
    sha256 cellar: :any,                 arm64_sonoma:  "ec4046a31ab824c7fa97428cb9274e45d45d7a4d5a11514dabb04eb411f162e5"
    sha256 cellar: :any,                 sonoma:        "b3a31211b943ebd2673fb210a2c3f756ba415a2ffc4799f2424231f7a014fa8e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c79607d753bfc4748f9b2ced9b0345e38332a0ecdbdadfcbbce8988aa4c4b0d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40cf3bf62294266578c2929f53edffefc7afa2629622b6aed3f73b9c5f2c79eb"
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