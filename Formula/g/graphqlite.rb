class Graphqlite < Formula
  desc "SQLite graph database extension"
  homepage "https://colliery-io.github.io/graphqlite/"
  url "https://ghfast.top/https://github.com/colliery-io/graphqlite/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "2b7c31bcd4acf94123e4b68c2a8a9fbb5b9c26e1b6a9b3b3fe077fea287dad48"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "04cc2fa7efdf30b236cded9b7633654ad66b0d1261572f52ea03dcbe759636a8"
    sha256 cellar: :any,                 arm64_sequoia: "8afaeba0747c89ffa8221e8a5e5e770776b53e5564b0a11081e65b354b91e9f3"
    sha256 cellar: :any,                 arm64_sonoma:  "2a9614d2c67e21246688b6e42264b76a5f8ffc335e99f3939549cfb8146c7e50"
    sha256 cellar: :any,                 sonoma:        "923eaa9d22d46c79845461d014dc88a9fa1a289b822d7ab9fe990f1a6ac21b22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "435d34a2146c22071fafc295b1391ec515e4959524ccfd8e7a6e14d2bda49261"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ad40620fd5aecfab248a08ebc05db236b35657dd36e60bb5877f94c85b34e8f"
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