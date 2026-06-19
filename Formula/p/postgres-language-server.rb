class PostgresLanguageServer < Formula
  desc "Language Server for Postgres"
  homepage "https://pg-language-server.com/"
  url "https://ghfast.top/https://github.com/supabase-community/postgres-language-server/archive/refs/tags/0.25.4.tar.gz"
  sha256 "43b5305a268ffaa297b22adb05350e4e2c08a9a398dea45bf6cf990d1e9c94d0"
  license "MIT"
  head "https://github.com/supabase-community/postgres-language-server.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d5bae62fe118023912d0e76f19e7417fecaa54a76928b27a2ea459b6798767c9"
    sha256 cellar: :any, arm64_sequoia: "6a5e473ce7555282e13de8ff1462d5d8b8d2ed9ec875d624cfff63b4e5ac06e9"
    sha256 cellar: :any, arm64_sonoma:  "ae7440985288b2081f2876e263c2a064d3e344b4fb7fb69736470c300fc6d593"
    sha256 cellar: :any, sonoma:        "5c14b751becf669e3e60c0b4188d4723d3c06e849c917d7b44159110a621699e"
    sha256 cellar: :any, arm64_linux:   "02b2a22a3f0adbadd5d2964ff86de3c6890d828e637ae10545dedbe98cd8c40c"
    sha256 cellar: :any, x86_64_linux:  "712f4e93860ef026c38dace0476af15153dcd8c05cbe512785fe85e46ccb4a01"
  end

  depends_on "llvm" => :build
  depends_on "node" => :build
  depends_on "rust" => :build
  depends_on "tree-sitter" => :build
  depends_on "tree-sitter-cli" => :build
  depends_on "libpg_query"

  def install
    ENV["PGLS_VERSION"] = version.to_s
    ENV["LIBPG_QUERY_PATH"] = Formula["libpg_query"].opt_prefix
    system "cargo", "install", *std_cargo_args(path: "crates/pgls_cli")
  end

  test do
    (testpath/"test.sql").write("selet 1;")
    output = shell_output("#{bin}/postgres-language-server check #{testpath}/test.sql", 1)
    assert_includes output, "Checked 1 file"
    assert_match version.to_s, shell_output("#{bin}/postgres-language-server --version")
  end
end