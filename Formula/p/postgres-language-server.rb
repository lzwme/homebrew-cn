class PostgresLanguageServer < Formula
  desc "Language Server for Postgres"
  homepage "https://pg-language-server.com/"
  url "https://ghfast.top/https://github.com/supabase-community/postgres-language-server/archive/refs/tags/0.25.1.tar.gz"
  sha256 "392b876c67841809d2fc5e1af9d7ad9498d942155d01fcfe7d2f9ee9d128d6a5"
  license "MIT"
  head "https://github.com/supabase-community/postgres-language-server.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e3c114ea0a7d85b5a87803e1966498dc3302f5b52abe4433aa64b6aa8c636f4a"
    sha256 cellar: :any, arm64_sequoia: "9c3c6c8ff18f1935ed3534d73cdc23d950844d46638cf49ce20f355579d45a2a"
    sha256 cellar: :any, arm64_sonoma:  "2683936ba0d69c1c8bd73ddee5ef29bede60d06f89ab804e5ba10ebb05a2abd1"
    sha256 cellar: :any, sonoma:        "54fb38ee1867e685c21e587822eb1518b28f5e07d8cf670bda0acc0053d5fcc2"
    sha256 cellar: :any, arm64_linux:   "9497ca238a0346c22ffcfaf3501eab1708a11d1f5192cd23ef84fc7e1322df99"
    sha256 cellar: :any, x86_64_linux:  "5b2edb61456e409f77fca09f640fd85effb8e63a9385ac4a6a9d04b0f63aa921"
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