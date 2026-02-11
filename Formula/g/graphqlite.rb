class Graphqlite < Formula
  desc "SQLite graph database extension"
  homepage "https://colliery-io.github.io/graphqlite/"
  url "https://ghfast.top/https://github.com/colliery-io/graphqlite/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "6a822f9a964e5bd96bd4b0a9e4bfda3f1f43d380951347d67fd4de3a9826390d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a690358261b26fcc567f88a789d2f612588ea18ef1c9e108c9fad48c2d08a905"
    sha256 cellar: :any,                 arm64_sequoia: "9de9204c9a556ff5021575e67598c1590af0959f33b3857a2037ec12f462d36f"
    sha256 cellar: :any,                 arm64_sonoma:  "024c065168e7ae7f1b71adcae7dd0229e6db84937e364defd7a6ed2598e14588"
    sha256 cellar: :any,                 sonoma:        "dc11f48b89c4cb9d49939a4b2144dc63e9c9a22a3e3ddb0d948e19d1ee48cca0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c852951384ac332349265b7909c859000ceaeaa147a4f7ea8ed24cece9867174"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69c30d5dda42ee03ca95dfbb10a6ade456424fae6326ca66bbeeac109c7d96d0"
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