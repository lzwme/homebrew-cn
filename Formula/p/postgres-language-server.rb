class PostgresLanguageServer < Formula
  desc "Language Server for Postgres"
  homepage "https://pg-language-server.com/"
  url "https://ghfast.top/https://github.com/supabase-community/postgres-language-server/archive/refs/tags/0.28.0.tar.gz"
  sha256 "fb8418ba92a2f81f2354bed15941512bb5a87e61fad7ef408c0db7a8d6fc9d5f"
  license "MIT"
  head "https://github.com/supabase-community/postgres-language-server.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f79ca52d48b86bb4ee2a8f71bd1aa52ac54952edc8fe21550757b47b96270793"
    sha256 cellar: :any, arm64_tahoe:       "786128443aa71154984b1aefcc0e58ce3ed5cdc09a95b8015c5297cf3cb1d5e1"
    sha256 cellar: :any, arm64_sequoia:     "1afee575995b04b5861d0208e3fa09c657ab9a9823e7a078319b4be0456c8a9d"
    sha256 cellar: :any, arm64_linux:       "64bcf22025af838a19136cce137d1f4090f9cbc9704f120030e30b60d87b0e89"
    sha256 cellar: :any, x86_64_linux:      "b31ddff7d355dc8a2e161c1806c86f31e0ab09f8a2617314fcea755a9bee1570"
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