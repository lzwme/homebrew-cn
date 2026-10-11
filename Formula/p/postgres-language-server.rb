class PostgresLanguageServer < Formula
  desc "Language Server for Postgres"
  homepage "https://pg-language-server.com/"
  url "https://ghfast.top/https://github.com/supabase-community/postgres-language-server/archive/refs/tags/0.28.1.tar.gz"
  sha256 "12255e5d5f81f8083ca389697458bfb2fa605a670803a464a1522c1000ccc5a9"
  license "MIT"
  head "https://github.com/supabase-community/postgres-language-server.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5ca05c5f232716d8677ab7c445abede898d9e5541e46a075b16d4ffe3d111134"
    sha256 cellar: :any, arm64_tahoe:       "e14ba36bb128f7bb7b3594aa1758f0bb3ff854cecdf0cbe3e9a3809fc1dcbb9c"
    sha256 cellar: :any, arm64_sequoia:     "6c3e42163c32b8a828af338a7767e789b07135260c4a74f465eaca458ff6e092"
    sha256 cellar: :any, arm64_linux:       "cd7eea3bea22fc34a61cc6609aa7db674c6ba7dcf6a373f0b95149309e1a2b8e"
    sha256 cellar: :any, x86_64_linux:      "8ec62447f9a691697fc8c7f7330c2adf248ed58e97576132c8aa02816de155b7"
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