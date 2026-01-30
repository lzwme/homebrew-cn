class Graphqlite < Formula
  desc "SQLite graph database extension"
  homepage "https://colliery-io.github.io/graphqlite/"
  url "https://ghfast.top/https://github.com/colliery-io/graphqlite/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "1d7ea89d7bbe870b42ba4e4bccddc6a52e00145ba558fc65433b79f2833431a3"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5743c97e126d536fb7edbd7039839d4d06cefbdc97b3d8e0034d2503158a4407"
    sha256 cellar: :any,                 arm64_sequoia: "cfcaca4c091e95e3b22ca2fcc2b90c943d3e21f6c3e2dfe146bcc21078ff929f"
    sha256 cellar: :any,                 arm64_sonoma:  "d746c5cb8c86fc27bd88920b77d81edb127ebf4597663cc63561d99a449341fd"
    sha256 cellar: :any,                 sonoma:        "237e3bc9323b4b35a8c881b5212d4aebcafda7cfc6bd4fc0c5d88c19e17f081c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4d0d05b78ca65379eda31cdf266e335b5e507211c053e14dbeeb80632a5317c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d98f4de8e5610939c1cf821ea00d7d4c8e3e632cc47b687aa6016794c12c4f2a"
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