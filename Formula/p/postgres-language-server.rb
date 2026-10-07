class PostgresLanguageServer < Formula
  desc "Language Server for Postgres"
  homepage "https://pg-language-server.com/"
  url "https://ghfast.top/https://github.com/supabase-community/postgres-language-server/archive/refs/tags/0.27.1.tar.gz"
  sha256 "b01992205042e4faa5c8c39cd6c7e1d77471497074176bb2f6946020f1e3d5fb"
  license "MIT"
  head "https://github.com/supabase-community/postgres-language-server.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a0d9837ce8964765785a3e47ebea3cf5d7e1bc611ef39fc4ea0e145abca3f2d0"
    sha256 cellar: :any, arm64_tahoe:       "3268c42e34509cf954e6187e2b811611cb5ac2959a5479246623845891c2b1ab"
    sha256 cellar: :any, arm64_sequoia:     "4c9d7b1b5d2e884b07f78f0d09c84425a68c93dc21793f2056dc3195e99c5f1b"
    sha256 cellar: :any, arm64_linux:       "9c5d1ab7f9bb8f7be8f35e73b73f888272aeeee375d1fec0032b91eef80b1cfe"
    sha256 cellar: :any, x86_64_linux:      "524b1922a7cc8344c93505117fad204976f5f15dd3f7966230d7f317c0f2d2b7"
  end

  depends_on "llvm" => :build
  depends_on "node" => :build
  depends_on "rust" => :build
  depends_on "tree-sitter" => :build
  depends_on "tree-sitter-cli" => :build
  depends_on "libpg_query"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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