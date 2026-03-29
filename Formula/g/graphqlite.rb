class Graphqlite < Formula
  desc "SQLite graph database extension"
  homepage "https://colliery-io.github.io/graphqlite/"
  url "https://ghfast.top/https://github.com/colliery-io/graphqlite/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "84c7d58dea00879e6c5b539c0230220f6570efd2f469e2d6dd1b45620a1e231f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f1b241edebaa2d2f903ebcd2465d101431841b15270713261e8e94878fafb303"
    sha256 cellar: :any,                 arm64_sequoia: "44b2c068cd1f97416d031076866990e1db0e8b29f1367faa1421c5c2de0760af"
    sha256 cellar: :any,                 arm64_sonoma:  "bd3175aee105692817f853928e74d671fbb0f79385c9c5a450abc040f1de8a35"
    sha256 cellar: :any,                 sonoma:        "2e76e8afa2040cb6d35205d979938aec57b2edb144d59403c8e6183d4098ed25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0dca5e09949396262ea2ee7bab946d8bfc29dbc3485ecda04bed73ea511b5fa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33be18cf2315bc1d40470a19b2ddbff0322b59358373431325c0149088793b3d"
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