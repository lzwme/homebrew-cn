class Graphqlite < Formula
  desc "SQLite graph database extension"
  homepage "https://colliery-io.github.io/graphqlite/"
  url "https://ghfast.top/https://github.com/colliery-io/graphqlite/archive/refs/tags/v0.3.8.tar.gz"
  sha256 "66589d32dc73e426e9fabbc4891bc77254ced92f151ea24587f9f57ea57e2615"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2ea1a66588f05d923fc4050ee3fb5fd11e0c00ffdc0c2942179328248b432dec"
    sha256 cellar: :any,                 arm64_sequoia: "d34edee08af0f6534cc6e0c4391dd120dee1f989acbd5b7fdec60c143ad8b6ea"
    sha256 cellar: :any,                 arm64_sonoma:  "f9efb7fbe1c13f4bc647b2ab2dbc068f05205aa09cfbe2ae9239ba15552c3321"
    sha256 cellar: :any,                 sonoma:        "2ff4f0b5c0b25d518e4ffafd1aab9fedf73ca9da262030b9add2d79f5e385cbc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db063588b43876f5b793500f28358bdbc0691d039fd8256646488de5ff11c04f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f6d0f5c85f84a72a8a123a69575ac040786f9b4572f7912031c4162c8ff0cb7"
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