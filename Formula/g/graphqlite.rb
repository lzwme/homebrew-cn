class Graphqlite < Formula
  desc "SQLite graph database extension"
  homepage "https://colliery-io.github.io/graphqlite/"
  url "https://ghfast.top/https://github.com/colliery-io/graphqlite/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "9be11d044528b591b61657878b67ed8be9177336b8943aa9480ffcc3b225f8ae"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e01449ab55623a16fe8b2baa6489248db9eb16d30d0aef10228393832cf95676"
    sha256 cellar: :any,                 arm64_sequoia: "4c439337c7219afa423829f5427d34d4065e66e8a93d018fd95e58e1d0e8db25"
    sha256 cellar: :any,                 arm64_sonoma:  "dbb74fb0d12f527e4c9019eb991be628479d778d45647b01a19ed23303bb8f09"
    sha256 cellar: :any,                 sonoma:        "cb06ee522bc4bc160b61833153bca4deca6b3b122993d1fa3c178044ff1fb4f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c8137c165a6e94565b8f432bce9441cdc018af2243617ebf790d38e1dec56c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c88a1d07632efce70dffac4ca56cb5cc4def599072366c966603fcf8dbcabfa"
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