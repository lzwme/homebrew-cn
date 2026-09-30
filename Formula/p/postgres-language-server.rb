class PostgresLanguageServer < Formula
  desc "Language Server for Postgres"
  homepage "https://pg-language-server.com/"
  url "https://ghfast.top/https://github.com/supabase-community/postgres-language-server/archive/refs/tags/0.26.0.tar.gz"
  sha256 "c01ed5ee8c019b4ac8d90a6db378e50a74cbde0a227cf28193b4fc092112a5b8"
  license "MIT"
  head "https://github.com/supabase-community/postgres-language-server.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "61756b4c8e2b532c3369d9c7d96fea96488d76b826ab8c1bd80936d1691c0639"
    sha256 cellar: :any, arm64_tahoe:       "581f3220b9e1b5c6fc007e23a235bf08f4218cd397843239acd92abba1cff18c"
    sha256 cellar: :any, arm64_sequoia:     "f7d031c1cd4ccc9b628b9010d472660de4282381da879134c12fe61586796548"
    sha256 cellar: :any, arm64_linux:       "b9a5ababc4c10ee4e10ca5764f1859eb03d6eb29130069f2db36e9f1f8e8b5a7"
    sha256 cellar: :any, x86_64_linux:      "15fc08b9f104718d452920c7dc06833af3d9133379afb097c3f2d21cb59db324"
  end

  depends_on "llvm" => :build
  depends_on "node" => :build
  depends_on "rust" => :build
  depends_on "tree-sitter" => :build
  depends_on "tree-sitter-cli" => :build
  depends_on "libpg_query"

  def install
    ENV["PGLS_VERSION"] = version.to_s
    ENV["LIBPG_QUERY_PATH"] = formula_opt_prefix("libpg_query")
    system "cargo", "install", *std_cargo_args(path: "crates/pgls_cli")
  end

  test do
    (testpath/"test.sql").write("selet 1;")
    output = shell_output("#{bin}/postgres-language-server check #{testpath}/test.sql", 1)
    assert_includes output, "Checked 1 file"
    assert_match version.to_s, shell_output("#{bin}/postgres-language-server --version")
  end
end