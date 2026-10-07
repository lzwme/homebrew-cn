class Graphqlite < Formula
  desc "SQLite graph database extension"
  homepage "https://colliery-io.github.io/graphqlite/"
  url "https://ghfast.top/https://github.com/colliery-io/graphqlite/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "a1fa49ad29bcfa05ce987157d3f7f8fa1494a1cf16f2f4b98599cf4121ee4080"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "20c46b40255d66770e128e70b51c77ff25e5cf12771cca4dd44f7acd4b767b6c"
    sha256 cellar: :any, arm64_tahoe:       "d6512fe3feaf551ad7f04ce5f2f2a11883d2d2416dd44e2716a0fdc9921a35a8"
    sha256 cellar: :any, arm64_sequoia:     "cbc356cd141bd046ace844b66e8aea25b4ec928f6d82a5ede135ddc567f20db2"
    sha256 cellar: :any, arm64_linux:       "18f89a516bdbb49329b391b90ec5e327d15fc32f72027cc7a22ad439199069a4"
    sha256 cellar: :any, x86_64_linux:      "4c13e1ddb054c170b64e782e3666dfcda3294409667858ec0918564aa48caa78"
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