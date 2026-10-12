class Graphqlite < Formula
  desc "SQLite graph database extension"
  homepage "https://colliery-io.github.io/graphqlite/"
  url "https://ghfast.top/https://github.com/colliery-io/graphqlite/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "497a5bf34652f7d5592c7dbf6529f7d7141e68d417e5c683d36ad3003c6c3ec6"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2eb0f68a4728651c1d4edb035b5f1d92c720fa92128eb3a1bf1a271f61008869"
    sha256 cellar: :any, arm64_tahoe:       "8c29f9be66bcb538faa5e03cd0f08ab64c432cf3e27b91a5b7b6c92450cba6d3"
    sha256 cellar: :any, arm64_sequoia:     "2f6a14413acd00b8b61ef19d73b2d251a4a355fe4c5e24b0e97b785c3c87ce09"
    sha256 cellar: :any, arm64_linux:       "93df2caf1367c2697ebfa796c2bdb890219fd12010dd2bd08296466ad86fce61"
    sha256 cellar: :any, x86_64_linux:      "23772e11208dbb0eff72d4d756a27a47522d353ba252e7eef1846bad1887ca45"
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
    assert_match '{"fof.name": "Charlie"}', pipe_output("#{formula_opt_bin("sqlite")}/sqlite3", sql)
  end
end