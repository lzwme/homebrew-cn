class Graphqlite < Formula
  desc "SQLite graph database extension"
  homepage "https://colliery-io.github.io/graphqlite/"
  url "https://ghfast.top/https://github.com/colliery-io/graphqlite/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "b6db75162cca7c364f6fafb169d1127d18130c622d367e4f5d1a97afb340b1f9"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1427d8e9f26e89661dc0686e6246de928879b95c42d0bd43c2dd3b06a2fb174d"
    sha256 cellar: :any,                 arm64_sequoia: "7ae6b9ff955f5a36ffacaf0a8eba5965c9a22c2dd37ecf608b05c515ae020d15"
    sha256 cellar: :any,                 arm64_sonoma:  "263a81f92d4b45299c938d4b469ba8c7f50b52a0a13a311e7dcc9c9f87b563f2"
    sha256 cellar: :any,                 sonoma:        "63c95c9edeeec5e2d08974794556b9899a5323b1ac3710bbdeb71575057605af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be7e9bd3800f362acbf6c76c239a731c412a3a123892fbe2ba16890cbcce4f20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16913196d002ee9ec59997da95dbf600c6bae9eaef84670f7cbdd7c0d9905a6e"
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