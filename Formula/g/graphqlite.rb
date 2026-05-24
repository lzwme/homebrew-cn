class Graphqlite < Formula
  desc "SQLite graph database extension"
  homepage "https://colliery-io.github.io/graphqlite/"
  url "https://ghfast.top/https://github.com/colliery-io/graphqlite/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "cf358d833f8d6dc47019a103a351335b3a1171b2a3eeb648957bccd4a8a97e07"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d6851c4b85847086011b1178e9a6c91f6b3433aa613c3811a45f437a13563819"
    sha256 cellar: :any,                 arm64_sequoia: "193c4017dde987a5ba4f74eb177bf43ec82a4b5d39bcaa7a33c49b20f885301d"
    sha256 cellar: :any,                 arm64_sonoma:  "0c68affc6a492ca12b3c00144a43aff02011b9d65c216006034ce3183370c6ef"
    sha256 cellar: :any,                 sonoma:        "ac92bef1b806b4e47d3f011cebaffed460cb77619cbc5a722cccc4d221301689"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0666cf22e8dd76e0ecc8c4bc92f8d592d1fadddbb4671f195f78a33d6c0c1b0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32b23d15619d5683681322ea8ce4d93a43a45a72c846260b40564c057f0e0947"
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