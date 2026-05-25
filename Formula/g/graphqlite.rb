class Graphqlite < Formula
  desc "SQLite graph database extension"
  homepage "https://colliery-io.github.io/graphqlite/"
  url "https://ghfast.top/https://github.com/colliery-io/graphqlite/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "2a1b3033d3690e84d59181ca91bb91f404b2157bb95c677a669215b0a72f5455"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "07165af9bbda35056e3848ea5fbf13847b388a586d8798866da4f2baff2049fe"
    sha256 cellar: :any,                 arm64_sequoia: "bcfcb49b4aa7a4992adb60ddddbb582de07f0dc2826da45d7cba35f0201e2486"
    sha256 cellar: :any,                 arm64_sonoma:  "cc98c31802429ac5e1e08ef14567b76f0f7aa17c1c73fd98a62c1c3918aa3ca0"
    sha256 cellar: :any,                 sonoma:        "bea55c157ede9d869dc995db591e11aceeab159ea3cf1351cb6ada07c11f8307"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ecb2c4633e9b8728c3ba12e1c4fa6c74407649d1da77a62f863a7f791aa6ab75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "361d2dae1f5f76421130aafb167593e657f4493321e1333022cfa822292c9b59"
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