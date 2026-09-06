class Graphqlite < Formula
  desc "SQLite graph database extension"
  homepage "https://colliery-io.github.io/graphqlite/"
  url "https://ghfast.top/https://github.com/colliery-io/graphqlite/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "f9813adfd38da67cdefcab96adfa91109c8cfb3269d04932c930d6914584ea4d"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b75a7d8832e84c32badfba75df0d1a20c3c173dde7cc9ac8876a030dbb59415f"
    sha256 cellar: :any, arm64_sequoia: "f7d144269c78c3631b46c07aa2b07c4a9299d910a98e405d3ed9085d1887cb37"
    sha256 cellar: :any, arm64_sonoma:  "b78fd1c6d448e07665386ca85c946d3404c9ae92b651525abcaba25bb0e41cfb"
    sha256 cellar: :any, arm64_linux:   "936e800b2d5991391f477f2933863677bb10a5c68bec803408604043aea73301"
    sha256 cellar: :any, x86_64_linux:  "0d39608ca63ec8e2ad557addd7706da26198a83d5fd9b644ab7ae14291a6b2d0"
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