class Graphqlite < Formula
  desc "SQLite graph database extension"
  homepage "https://colliery-io.github.io/graphqlite/"
  url "https://ghfast.top/https://github.com/colliery-io/graphqlite/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "3879e244a0b01dcea6790e1fb11577550b214ad0b63f6e4751ef11d3ca8c79fd"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "704d229c161cab368c1084978b129c7a81f31e27208d9a5dc3cc657615c7b15b"
    sha256 cellar: :any, arm64_sequoia: "f281621a9ffceabf6e7f27bca8216a756e916a2832428bdb85d5b36f64112198"
    sha256 cellar: :any, arm64_sonoma:  "e23770f58720f886fd3762b259e6f30fbe019fb3d32df183076107dce880b4d6"
    sha256 cellar: :any, arm64_linux:   "528de578402e285bf90280742e39592d7c4bba4647de660f5c150bf8d5a2ac6a"
    sha256 cellar: :any, x86_64_linux:  "e86ece009b28053be42511474119241248a658a7f16bcb2b80fd51746be604cb"
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